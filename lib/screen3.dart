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
  TextEditingController tcr = new TextEditingController();
  String? subbed;
  String? name;
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString('name');
    setState(() {});
    print("hello $name");
  }

  TextEditingController tc = new TextEditingController();
  var selected = 1;
  Future<void> sub(String value) async {
    var text = value;
    print(value);
    setState(() {
      subbed = null;
      tc.clear();
    });
    Dio()
        .post("http://localhost:3000/mid", data: {'name': name, 'file': text})
        .then((res) => {
          print(res.data['code']),

          setState(() {
            subbed = res.data['code'];
          })
          });
  }

  Future<void> filep() async {
    FilePickerResult? fr = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: Column(
          children: [
            SegmentedButton(
              segments: [
                ButtonSegment(value: 1, label: Text("Text")),
                ButtonSegment(value: 2, label: Text("File")),
                ButtonSegment(value: 3, label: Text("Retrive")),

              ],
              selected: {selected},
              onSelectionChanged: (p0) => {
                setState(() {
                  selected = p0.first;
                  print(selected);
                }),
              },
            ),
            SizedBox(height: 20),
            selected == 1
                ? TextField(
                    controller: tc,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                    ),
                    onSubmitted: (value) => {sub(value)},
                  )
                : selected==2? Flexible(
                    flex: 3,
                    child: InkWell(
                      onTap: () => filep(),
                      child: Container(
                        child: Text("Pick files (one at a time)"),
                      ),
                    ),
                  ):Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        TextField(controller: tcr ,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8) 
                          )
                        ),
                        onTap: () => retrieve,
                        )
                      ],
                    ),
                  ),
            subbed==null? ElevatedButton(
              onPressed: () => sub(tc.text),
              child: Text("Submit"),
            ):InkWell(
              onTap: () => print("subbed is clicked ${subbed.toString()}"),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 5,),
                    Text("Your retreival code is : "),
                    SizedBox(height: 3,),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text("${subbed.toString()}")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
