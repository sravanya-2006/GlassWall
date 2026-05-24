import 'package:flutter/material.dart';
import 'package:glasswall/main.dart';
// import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
class setup extends StatefulWidget {
  const setup({super.key});

  @override
  State<setup> createState() => _setupState();
}

class _setupState extends State<setup> {
  
  
  TextEditingController tc = new TextEditingController();

  Future<void> set(String s)async{
    SharedPreferences pref  = await SharedPreferences.getInstance();
    await pref.setString("name", s);
    print(s);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>s1()));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: TextField(
          controller: tc,
          onSubmitted: (value) => set(tc.text),
          
        ),
      ),
    );
  }
}