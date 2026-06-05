import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:glasswall/screen1.dart';
import 'package:glasswall/screen2.dart';
import 'package:glasswall/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main(){
  
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'mont',
      colorScheme: ColorScheme.light(
        surface: Color(0xFFFDFBF7)
      ),

      
    ),
    darkTheme: ThemeData(fontFamily: 'gsan',colorScheme: ColorScheme.dark(
      surface: Color(0xFF0B111E)
      // errorContainer: const Color.fromARGB(255, 69, 29, 29)
    )),
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
    // prefs.clear();
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: scaff,
      drawer: Drawer(
       
        
        child: ListView(
        
          padding: EdgeInsets.all(13),
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
              top: 3,
              left: 0,
              child: IconButton(onPressed:()=> scaff.currentState?.openDrawer(), icon: Icon(Icons.auto_awesome_mosaic_outlined)))
            ,
            Positioned(top: 4.5,
              left: 50,child: Text("GlassWall",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24),)),

            Positioned.fill(child: screens[curr]),
        
            Positioned(left: 29,right: 29,bottom: 16,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: LiquidGlassLayer(
                  settings: LiquidGlassSettings(
                    thickness: 10,
                    blur: 20,
                    lightIntensity: 1.5,
                    
                   saturation: 1.2,
                    // glassColor: Color.fromARGB(15, 255, 255, 255)
                  ),
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(borderRadius: 50,side: BorderSide.none,),
                    child: SizedBox(
                      height: 60,
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