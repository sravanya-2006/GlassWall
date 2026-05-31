import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glasswall/screen1.dart';
import 'package:glasswall/screen2.dart';
import 'package:glasswall/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'mont',
      colorScheme: ColorScheme.light(),

      
    ),
    darkTheme: ThemeData(fontFamily: 'mont',colorScheme: ColorScheme.dark()),
    themeMode: ThemeMode.system,
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
  final GlobalKey<ScaffoldState> scaff = GlobalKey<ScaffoldState>();
  // Color bg = Colors.black;
  String? s;
  @override
  void initState(){
    super.initState();
    check();
  }
  Future<void> check()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     s = prefs.getString("name");
    print(s);
    setState(() {
      
    });
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
      key: scaff,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(3),
          children: [
            DrawerHeader(child: Text("Wt's ups  $s  ??",style: TextStyle(fontWeight: FontWeight.w900),)),
            ListTile(leading: Icon(Icons.search),title: Text("data"),)
          ],
        ),
      ),
      // backgroundColor: bg,


      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(18),child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(onPressed:()=> scaff.currentState?.openDrawer(), icon: Icon(Icons.menu)))
            ,

            Positioned.fill(child: screens[curr]),
        
            Positioned(left: 16,right: 16,bottom: 16,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20,sigmaY: 20),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                       color: Colors.white.withValues(alpha: 0.05), // lower = more transparent
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)],
                      ),
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
                    ),
                  ),
                ),
              ))
          ],
        
        ),),
      ),
    );
    
  }
}