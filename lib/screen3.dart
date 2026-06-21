import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String? name;
  void initState(){
    super.initState();
    init();
  }
  Future<void> init()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString('name');
    setState(() {
      
    });
    print("hello $name");

  }
  TextEditingController tc = new TextEditingController();
  var selected =1;
  Future<void> sub(String value)async{

    var text = value;
    print(value);
                setState(() {
                  tc.clear();
                });
  Dio().post("http://localhost:3000/mid",data: {
    'name': name,
    'file': text
  }).then((res)=>print(res.data));
  
  }
  Future<void> filep()async{
    FilePickerResult? fr = await FilePicker.platform.pickFiles(allowMultiple: false);

  }
  @override

  
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          children: [
            SegmentedButton(segments: [
              ButtonSegment(value: 1,label: Text("Text")),
              ButtonSegment(value:2,label: Text("File"))
            ], selected: {selected},
            onSelectionChanged: (p0) => {
              setState(() {
                selected = p0.first;
                print(selected);

              })
            },
            
            ),
            SizedBox(height: 20,),
            selected==1? TextField(
              controller: tc,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(23)
                )
              ) ,
              onSubmitted: (value) =>{
                sub(value)
              },
            ):Flexible(
              flex: 3,
              child: InkWell(
                onTap: () => filep(),
                child: Container(
                  child: Text("Pick files (one at a time)"),
                ),
              ),
            ),
            ElevatedButton(onPressed: ()=>sub(tc.text), child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}