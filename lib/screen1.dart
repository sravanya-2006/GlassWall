

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
   List picked = [];
  Registration ? reg;
  bool isreg = false;
  @override
  void initState(){
    super.initState();
    startreg();
    print("init state called for the share page");
  }
  
  Future<void>   filepicker()async{
    FilePickerResult? res = await FilePicker.platform.pickFiles(allowMultiple: true);
    if(res==null)return;
    setState(() {
      picked = res.files;
    })
    ;
    
    print(picked[0].name);}
  Future<void> startreg()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");
   try{
     reg = await register(Service(
      name: '$name',
      type: '_OnlyFiles._tcp',
      port: 6969,
    ));
    if(!mounted)return;
    setState(() {
      isreg = true;
    });
    print("ahh bro im visible now!!!!!!!!!!!!!!!!!!");
   }
   catch(e){
    print(e);
   }
  }
  @override
  void dispose(){
    if(reg!=null) unregister(reg!);
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
    child: Padding(padding: 
    EdgeInsets.all(8),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          
        //  isreg? Text("Receiver mode on pls wait for someone to send u something...",style: TextStyle()):Text("Reciever mode is not on idk why.... it shoukld be on as soon as u switched to screen1"),
        picked.isEmpty?ElevatedButton(onPressed:filepicker , child: Text("Upload Files")):SizedBox(
          height: MediaQuery.of(context).size.height*0.400,
      
          child: ListView.builder(itemCount: picked.length,itemBuilder: ((context, index) =>SizedBox(
            height: 80, width: 150,
            child: Card(child: ListTile(
              title:Text('${picked[index].name}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
              leading: Icon(Icons.file_copy),
              subtitle: Text('${picked[index].size}',style: TextStyle(fontSize: 8,)),
            ),),
          ) )),
        ),
        picked.isEmpty?Text("Please pick from "):Text('Total items:  ''${picked.length}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
         
          
        ],
        
      ),
    ),
    ),
  );
  }
}