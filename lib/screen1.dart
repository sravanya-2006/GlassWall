

import 'dart:ffi';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
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
  var currpg = 0;
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
        // print(picked[0].ext);

    

    
    
    
    
    
    
    
    
    
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
    PageController pc = PageController(viewportFraction: 0.8);
    return Padding(padding: 
    EdgeInsets.all(6),
    child: SizedBox(
      height: MediaQuery.of(context).size.height*0.99,
       width: MediaQuery.of(context).size.width*0.95,
      child: picked.isEmpty?
      Column(
        children: [
          Flexible(
            flex: 5,
            child: InkWell(
                  onTap: () => filepicker(),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: isDark? Image.asset(
                          
                           'ass/can2.png',
                             fit: BoxFit.cover,
                             alignment: Alignment.topRight
                            
                        ):Image.asset(
                          
                           'ass/can1.png',
                             fit: BoxFit.cover,
                             alignment: Alignment.topCenter
                        
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
                        children: [
                          Flexible(flex: 7,child: DefaultTextStyle(textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width>600&&MediaQuery.of(context).size.width<800?46:29,
                              color: isDark?const Color.fromARGB(255, 251, 233, 216):Color(0xFF331B0D),fontFamily: 'opensauce'),
                            child: AnimatedTextKit(
                              
                              isRepeatingAnimation: true,
                              repeatForever: true,
                          
                              
                              animatedTexts: [
                          
                              FadeAnimatedText(duration: Duration(milliseconds: 6000),fadeOutBegin: 0.8,fadeInEnd: 0.5,"Click here to start sharing files"),
                               FadeAnimatedText(duration: Duration(milliseconds: 4500),fadeOutBegin: 0.4,fadeInEnd: 0.2,"All types of files are supported"),
                                FadeAnimatedText(duration: Duration(milliseconds: 5000),fadeOutBegin: 0.8,fadeInEnd: 0.5,"Make sure that the devices are on same network")
                            ]),
                          )),
                      Flexible(flex: 2,child: Container())
                        ],
                      ),
                    )
                      ],
                    ),
                  )
                ),
          ),
              // Spacer(flex: 1,),
              SizedBox(height:50 ,),

              Flexible(flex: 2,child: Text("Recivers  will appear here once u select files"))
        ],
      ):
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          children: [
            Expanded(
              child: PageView.builder(onPageChanged: (value) => setState(() {
                currpg = value;
                print(currpg);
              })
              ,controller: pc,itemCount: picked.length,itemBuilder: (c,i)=>
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: currpg==i?0.9:0.85,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.bounceIn,
                        child: ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: isDark? Image.asset(
                          
                           'ass/can2.png',
                             fit: BoxFit.cover,
                            //  alignment: Alignment.topRight
                            
                        ):Image.asset(
                          
                           'ass/can1.png',
                             fit: BoxFit.cover,
                            //  alignment: Alignment.topCenter
                        
                        )
                                          ),
                      ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ListTile(
                        title: Text("${picked[i].name}",style: TextStyle(fontWeight: FontWeight(700),fontSize: 26),maxLines: 2,overflow: TextOverflow.fade,),
                        subtitle: Text("${(picked[i].size/1000000)} mb",maxLines: 1,overflow: TextOverflow.fade,),
                      ),
                    ),
                  )
                    ],
                  ),
                )
                
                ),
            ),
             SizedBox(height: 10,),

                      !recs.isEmpty?Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          itemCount: recs.length,
                          itemBuilder: (c,i)=>
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 70,
                              maxWidth: 50
                            ),
                            decoration: BoxDecoration(
                              color:Colors.white ,
                              borderRadius: BorderRadius.circular(19),
                              boxShadow: [
                                BoxShadow(offset: Offset(3, 1),color: const Color.fromARGB(40, 0, 0, 0),blurRadius: 30,spreadRadius: 8)
                              ]
                            ),
                            child: InkWell(onTap: () => send(recs[i]),child: ListTile(leading: Icon(Icons.person_2),title: Text("${recs[i].name}"),))),
                          
                          
                        ),
                      ):CircularProgressIndicator.adaptive()
                    ]
          
        ),
      )
      
             
            
    ),
    );
  }
}