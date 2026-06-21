import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Discovery? dis;
  List<Service> senders = [];
  String? name;
  Registration ? reg;
  bool isreg = false;
  List<String> recfiles = [];
  HttpServer? server;
  Directory? dir;

  @override
  void initState() {
    super.initState();
    ser();
    startreg();
  
  }

  Future<void> startreg()async{
     print("assta lavista baby");
   
   try{
     print("psuhhhh");
     SharedPreferences prefs = await SharedPreferences.getInstance();
    //  prefs.clear();
     name = prefs.getString("name");
     reg = await register(Service(
      name: '$name ',
      type: '_pandawannashare._tcp',
      
      port: 6969,
    ));
    if(!mounted){
      print("not mounted");
      return;};
    setState(() {
      isreg = true;
    });
    print("ahh bro im visible now!!!!!!!!!!!!!!!!!!");
   }
   catch(e,st){
    print("error $e");
    print("error $st");
   }
  }
  Future<void> ser()async

  {
        SharedPreferences pref =  await SharedPreferences.getInstance();
        String? loc = pref.getString("chosen");
        
    try{
       server = await HttpServer.bind(InternetAddress.anyIPv4, 6969);
     print("server is up");
     server!.listen((HttpRequest req)async{
      if(req.uri.path=='/wannarecieve'){
        String fname = req.headers.value('filename')??'Whats in the box !!! Whats in the boxxx ';
        String hisname = req.headers.value('myself')!;
        
        bool? accepted = await showDialog<bool>(context: context, builder: (c)=>AlertDialog(title: Text("${hisname} wants to send u something  "),
        content: Text("Total count : ${req.headers.value('count')} \n $fname "),
        actions: [TextButton(onPressed: ()=>Navigator.pop(c,false) , child: Text("Reject")),TextButton(onPressed: ()=>Navigator.pop(c,true), child: Text("Accept"))],));
        if(accepted!){
          req.response..statusCode = 200..close();

        }
        else{req.response..statusCode = 403..close();}
        
      }
      
      else if(req.uri.path=='/Enjoy'){
        String fname = req.headers.value('filename')??'Whats in the box !!! Whats in the boxxx ';
        if(loc==null){
           dir = await getApplicationDocumentsDirectory();
        }
        else{
           dir = await Directory(loc!);
        }
        
        File file = File('${dir!.path}/$fname');
        IOSink sink = file.openWrite();
        await req.cast<List<int>>().pipe(sink);
        await sink.close();

        req.response..statusCode =200..close();
        if(mounted){
          recfiles.add(file.path);
          print("Files recieved");
        }
        
      }
     });
    }
    catch(e){
      print(e.toString());
    }
  }


  @override
  void dispose() {
    // if (dis != null) stopDiscovery(dis!)
    if(reg!=null)unregister(reg!);
    server!.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return senders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Scanning for senders..."),
              ],
            ),
          )
        : ListView.builder(
            itemCount: senders.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: Icon(Icons.phone_android),
              title: Text(senders[i].name ?? 'Unknown'),
              subtitle: Text('${senders[i].host}:${senders[i].port}'),
              onTap: () {
                // → connect + receive file here
              },
            ),
          );
  }
}