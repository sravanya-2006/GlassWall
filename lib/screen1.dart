

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nsd/nsd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';



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
  @override
  void initState(){
    super.initState();
    // startreg();
    startdis();
    print("init state called for the share page");
  }
   Future<void> startdis() async {
    SharedPreferences pref  = await SharedPreferences.getInstance();
    name = pref.getString("name");
    setState(() {
      
    });

    dis = await startDiscovery('_OnlyFiles._tcp');
    dis!.addServiceListener((guys, status) {
      if (!mounted) return;
      setState(() {
        if (status == ServiceStatus.found) {
          if (!recs.any((i) => i.host == guys.host && i.port == guys.port)) {
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
    
    print(picked[0].name);}
    
  // Future<void> startreg()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? name = prefs.getString("name");
  //  try{
  //    reg = await register(Service(
  //     name: '$name',
  //     type: '_OnlyFiles._tcp',
  //     port: 6969,
  //   ));
  //   if(!mounted)return;
  //   setState(() {
  //     isreg = true;
  //   });
  //   print("ahh bro im visible now!!!!!!!!!!!!!!!!!!");
  //  }
  //  catch(e){
  //   print(e);
  //  }
  // }
  
  @override
  void dispose(){
    if(reg!=null) unregister(reg!);
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
    child: Padding(padding: 
    EdgeInsets.all(25),
    child: Column(
    children: [
      picked.isEmpty?Column(
        children: [
          LottieBuilder.asset('ass/popcorn.json'),
          ElevatedButton(onPressed: ()=>filepicker(), child: Text("Pick files to continue further...",style: TextStyle(fontWeight: FontWeight.w400),)),
        ],
      ):
      Center(
        child: Expanded(child: ListView.builder(itemCount: picked.length,itemBuilder: (c,i)=>Center(
          child: Container(
            // color: Colors.red
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white)
            ),
            child: ListTile(
              leading: Icon(Icons.file_copy_rounded),
              title: Text("${picked[i].name}"),
            ),
          ),
        ))),
      ),
      if(picked.isNotEmpty)...[
        Expanded(child: SizedBox(
          height: 600,
          child: recs.isNotEmpty?ListView.builder(itemCount: recs.length,itemBuilder: (c,i)=>ListTile(
            title: Text('${recs[i].name}'),
          )):Text("Pls w8")

        ))
      ]
    ],
     
    
      
    ),
    ),
  );
  }
}