

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nsd/nsd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;



class Screen1 extends StatefulWidget {
 
  const Screen1(
  {super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
String? name;
   List picked = [];
  Registration ? reg;
  bool isreg = false;
    Discovery? dis;
  List<Service> recs = [];
  var temp;
  @override
  void initState(){
    super.initState();
   
    startdis();
    print("init state called for the share page");
  }
   Future<void> startdis() async {
    SharedPreferences pref  = await SharedPreferences.getInstance();
    name = pref.getString("name");
    setState(() {
      temp = name;
      
    });

    dis = await startDiscovery('_pandawannashare._tcp');
    dis!.addServiceListener((guys, status) {
      print("object");
      if (!mounted) return;
      setState(() {
        if (status == ServiceStatus.found) {
          if (guys.name!=temp&&!recs.any((i) => i.host == guys.host && i.port == guys.port)) {
            recs.add(guys);
          }
        } else if (status == ServiceStatus.lost) {
          recs.removeWhere((i) => i.host == guys.host && i.port == guys.port);
        }
      });
    });
  }
  
  Future<void>   filepicker()async{
    FilePickerResult? res = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(res==null)return;
    setState(() {
      picked = res.files;
    })
    ;
    
    print(picked[0].name);
    
    
    
    
    
    
    
    
    
  }
  Future<void> send(Service rec) async{
    print("sender is on");
    if(picked.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hello genius!!!! u might wantv to pick some files before clicking on a reciever.")));
      return;

    }
    if(rec.host==null)return;
    for(var pf in picked){
      File fi = File(pf.path!);
      var ask = await http.get(Uri.parse('http://${rec.host}:${rec.port}/wannarecieve'),headers: {'filename':pf.name,'myself':name??'John Krishna'});
      if(ask.statusCode==403){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uk this guy??? ")));
          
          return;
        }
      }
       try{
      var req = http.StreamedRequest('POST', Uri.parse('http://${rec.host}:${rec.port}/Enjoy'));
      req.headers['filename']= pf.name;
      req.contentLength = await fi.length();
      fi.openRead().listen(
        (chunk){
        req.sink.add(chunk);
      },
      onDone: () async {
        req.sink.close();
      },
      );

      var response = await req.send();
      if(response.statusCode ==200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("DONE")));
      }
      
    }
    catch(e){
      print(e.toString());
    }
    }
   

  }
    

  
  @override
  void dispose(){
    if(dis!=null)stopDiscovery(dis!);
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness==Brightness.dark;
    PageController pc = PageController(viewportFraction: 0.77);
    return Center(
    child: Padding(padding: 
    EdgeInsets.all(5),
    child: SizedBox(
      height: MediaQuery.of(context).size.height*0.86,
      width: MediaQuery.of(context).size.width*0.86,
      child: picked.isEmpty?Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset('ass/wait.json',filterQuality: FilterQuality.high,fit: BoxFit.cover,),
              ElevatedButton(onPressed: ()=>filepicker(), child: Text("Pick files to continue further...",style: TextStyle(fontWeight: FontWeight.w400),)),
              // Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since 1966, when designers at Letraset and James Mosley, the librarian at St Bride Printing Library, took a 1914 Cicero translation and scrambled it to make dummy text for Letraset's Body Type sheets. It has survived not only many decades, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised thanks to these sheets and more recently with desktop publishing software including versions of Lorem Ipsum.")
            ],
          ),
        ),
      ):Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          children: [
            SizedBox(height: 23,),
            Container(
              
              constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3, // Your max height limit
          ),
              
          
                
                
                child: PageView.builder(controller: pc,itemCount: picked.length,itemBuilder: (c,i)=>
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                color: isDark?Color(0xFF12161A):Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(23)
                            ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                      
                          // color: isDark?Color(0xFF12161A):Color(0xFFF5F5F7),
                         Expanded(child: Text(" ${i+1}.  ${picked[i].name} ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),overflow: TextOverflow.ellipsis,)),
                    
                        
                        
                        Divider(height: 2,)
                                  
                        
                                  
                       
                      ],
                    ),
                  ),
                )
                
                ),
              
            ),
             Divider(thickness: 3,),
                      !recs.isEmpty?Expanded(child: ListView.builder(
                        itemCount: recs.length,
                        itemBuilder: (c,i)=>TextButton(
                          child: Text("${recs[i].name}"),
                          onPressed: ()=>send(recs[i]),
                        ),
                        
                      )):CircularProgressIndicator.adaptive()
                    ]
          
        ),
      )
      
             
            
    ),
    ),
  );
  }
}