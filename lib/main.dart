import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:glasswall/screen1.dart';
import 'package:glasswall/screen2.dart';
import 'package:glasswall/screen3.dart';
import 'package:glasswall/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

void main(){
  
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'gsan',
      colorScheme: ColorScheme.light(
        // surface: Color.fromARGB(255, 245, 242, 236)
      ),

      
    ),
    darkTheme: ThemeData(fontFamily: 'gsan',colorScheme: ColorScheme.dark(
      surface: Color.fromARGB(255, 0, 2, 7)
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
    Screen3(),
  ];
  Future <void> change() async{
    SharedPreferences pref =  await SharedPreferences.getInstance();
    String? chosen = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Where should received files go?',
      
    );
    await pref.setString('chosen', chosen!);
  }
  int curr = 0;
  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text("GlassWall"),
        leading: IconButton(onPressed:()=> scaff.currentState?.openDrawer(), icon: Icon(Icons.menu_rounded)),
      ),
      key: scaff,
      drawer: Drawer(
       
        
        child: ListView(
        
          padding: EdgeInsets.all(8),
          children: [
            DrawerHeader(child: Text("Wt's ups  $s  ??",style: TextStyle(fontWeight: FontWeight.w900),)),
            ListTile(leading: Icon(Icons.search),title: Text("data"),),
            TextButton(onPressed: ()=> change(), child: Text("location"))
          ],
        ),
      ),
      // backgroundColor: bg,


      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(18),child: Stack(
          children: [

            Positioned.fill(child: screens[curr]),
        
            Positioned(left: sw/15,right: sw/15,bottom: 5,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Container(

                  decoration: BoxDecoration(
                    color: isDark?Color.fromARGB(255, 32, 32, 32):Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                                  BoxShadow(offset: Offset(0, 4),blurRadius: 40,spreadRadius: 6,color:  isDark? Color.fromARGB(129, 63, 64, 50):const Color.fromARGB(31, 150, 26, 26)),
                                  
                                ]
                  ),
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
              ))
          ],
        
        ),),
      ),
    );
    
  }
}