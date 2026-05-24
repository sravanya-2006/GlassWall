

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nsd/nsd.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Screen1 extends StatefulWidget {
 
  const Screen1(
  {super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  Registration ? reg;
  bool isreg = false;
  void initState(){
    super.initState();
    startreg();
    print("init state called for the share page");
  }
  
  Future<void> startreg()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = await prefs.getString("name");
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
  void dispose(){
    if(reg!=null) unregister(reg!);
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Center(
    child: Padding(padding: 
    EdgeInsets.all(23),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
       isreg? Text("Receiver mode on pls wait for someone to send u something...",style: TextStyle()):Text("Reciever mode is not on idk why.... it shoukld be on as soon as u switched to screen1"),
        Container(height: 600,width: 600,alignment: Alignment.center,child: LottieBuilder.asset("./ass/popcorn.json",fit: BoxFit.fill,)),
      ],
    ),
    ),
  );
  }
}