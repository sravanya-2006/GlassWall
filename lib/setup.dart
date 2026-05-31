import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:glasswall/main.dart';
// import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_names_generator/unique_names_generator.dart';
class setup extends StatefulWidget {
  const setup({super.key});

  @override
  State<setup> createState() => _setupState();
}

class _setupState extends State<setup> {

  void initState(){
  
    super.initState();
    set();
  }
  String? n ; 
  
  
  TextEditingController tc = TextEditingController();

  Future<void> set()async{
    final genie = UniqueNamesGenerator(config: Config(dictionaries: [animals,adjectives ],length: 2),);

    SharedPreferences pref  = await SharedPreferences.getInstance();
      n =  genie.generate();
     setState(() {
      
     });
    await pref.setString("name", n!);
    print('he;llllo $n');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: n!=null?AnimatedContainer(

       duration: Duration(microseconds: 700),
          
            decoration: BoxDecoration(
              gradient: RadialGradient(radius: 2,colors: [
                Colors.red,Colors.black,Colors.transparent
              ])
            ),
          
        child: Row(
          children: [
            
            Text("Hello",style: TextStyle(fontWeight: FontWeight.w700,color: const Color.fromARGB(255, 30, 213, 143)),),
            AnimatedTextKit(isRepeatingAnimation: false,
            onFinished: () => 
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>s1()))

            ,
            pause: Duration(microseconds: 600),
            animatedTexts: [
              FadeAnimatedText('     $n')
            ]),
          ],
        ),
      ):CircularProgressIndicator(),
    );
  }
}