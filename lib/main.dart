import 'package:flutter/material.dart';
import 'package:glasswall/screen1.dart';
import 'package:glasswall/screen2.dart';
import 'package:glasswall/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: s1(),
  ));
}
class s1 extends StatefulWidget {
  const s1({super.key});

  @override
  State<s1> createState() => _s1State();
}

class _s1State extends State<s1> {
  String? s;
  void initState(){
    super.initState();
    check();
  }
  Future<void> check()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     s = await prefs.getString("name");
    print(s);
    if(s==null){

     WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => setup()));
    });
    }
  }
  List<Widget> screens = [
    Screen1(),
    Screen2(),
    Center(child: Text("Screen3"),),
  ];
  int curr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(padding: EdgeInsets.all(18),child: Stack(
        children: [
          Positioned.fill(child: screens[curr]),

          Positioned(left: 16,right: 16,bottom: 30,
            child: Container(height: 60,decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [BoxShadow(color: const Color.fromARGB(39, 0, 0, 0),offset: Offset(2, 2),blurRadius: 23)]

            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: ()=>{
                    setState(() {
                      curr =0;
                    })
                  }, icon: Icon(Icons.send_rounded,),),
                  IconButton(onPressed: ()=>{
                    setState(() {
                      curr =1;
                    })
                  }, icon: Icon(Icons.receipt_rounded,)),
                  IconButton(onPressed: ()=>{
                    setState(() {
                      curr =2;
                    })
                  }, icon: Icon(Icons.cloud_upload_outlined))
                ],
              ),
            ),))
        ],

      ),),
    );
    
  }
}