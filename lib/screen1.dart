

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
  bool sending = false;
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
    print(picked[0].path);
        print(picked[0].ext);

    

    
    
    
    
    
    
    
    
    
  }
  Future<void> send(Service rec) async{
    print("sender is on");
    if(picked.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hello genius!!!! u might wantv to pick some files before clicking on a reciever.")));
      return;

    }
    if(rec.host==null)return;
    String hos = rec.host!;
    final address = await InternetAddress.lookup(hos,type: InternetAddressType.IPv4);
    final host = address.first.address;
    
      
      var ask = await http.get(Uri.parse('http://${host}:${rec.port}/wannarecieve'),headers: {'filename':picked[0].name,'myself':name??'John Krishna','count':picked.length.toString()});
      if(ask.statusCode==403){
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Uk this guy??? ")));
          
          return;
        }
      }
    for(var pf in picked){
      File fi = File(pf.path!);
      
       try{
        setState(() {
        sending = true;
        });
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
    EdgeInsets.all(6),
    child: SizedBox(
      height: MediaQuery.of(context).size.height*0.95,
      width: MediaQuery.of(context).size.width*0.95,
      child: picked.isEmpty?Center(
        child: InkWell(
  onTap: () => filepicker(),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: Stack(
      // Centers children in the stack
      children: [
        // The image is the base layer
        Image.asset(
          'ass/gg.jpeg',
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height*0.8,
      width: MediaQuery.of(context).size.width*0.97,
        ),
        // The text is placed over the image
        Positioned( left: 3,
        top: 6,
          child: const Text(
            "Pick Files to get Started",
            style: TextStyle(
            
              color: Colors.white, // Ensure high contrast with image
              fontSize: 16,
              fontWeight: FontWeight.w700
              // Optional: add a semi-transparent background
            ),
          ),
        ),
      ],
    ),
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
                    child: ClipRRect(
                      child: Stack(
                        children: [
                          // LottieBuilder.asset('ass/scan.json'),
                          ClipRRect(borderRadius: BorderRadiusGeometry.circular(16),child: Image.file(File(picked[i].path,),fit: BoxFit.cover,height: double.infinity,width: double.infinity,)),
                          Container(decoration: BoxDecoration(color: Colors.white),child: Text("${picked[i].name}", textAlign: TextAlign.center,))
                        ],
                      ),
                    ),
                  )
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