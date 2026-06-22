import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String? path;
  bool? loading;
  FilePickerResult? fr;
  String? resu;
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
    path = pref.getString('chosen');
    setState(() {});
    print("hello $name");
  }

  TextEditingController tc = new TextEditingController();
  var selected = 1;
  Future<void> sub(String nam, String value, int val) async {
    setState(() {
      loading = true;
    });
    if (value == null) return;
    var text = value;
    print(value);
    setState(() {
      subbed = null;
      tc.clear();
    });
    Dio()
        .post(
          "https://glassnode-ga1o.onrender.com/mid",
          // "https://glass-node-uezc-5hht5zsei-crazycat8686s-projects.vercel.app/mid",
          data: {'name': nam, 'file': text, 'type': val.toString()},
        )
        .then(
          (res) => {
            print(res.data['code']),

            setState(() {
              subbed = res.data['code'];
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(" successfull!!!! ur code is \n  $subbed"),
                ),
              );
            }),
          },
        );

    setState(() {
      loading = false;
    });
  }

  Future<void> filep() async {
    FilePickerResult? fr = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    print(fr!.files.first.path);
    String? path = fr!.files.first.path;
    String? name = fr!.files.first.name;

    File fi = File(fr!.files.first.path!);
    List<int> bytes = await fi.readAsBytes();
    String encoded = base64Encode(bytes);
    sub(name, encoded, 1);
  }

  Future<void> retrieve(String s) async {
    ;
    setState(() {
      loading = true;
    });
    var res = await Dio().get("https://glassnode-ga1o.onrender.com/find/$s");

    if (res.data['type'] == '0') {
      setState(() {
        resu = res.data['file'];
      });
    } else {
      String encoded = res.data['file'];

      List<int> bytes = base64Decode(encoded);

      if (Platform.isAndroid) {
        String outputPath = "$path/${res.data['name']}";
        await File(outputPath).writeAsBytes(bytes);
      } else {
        String? outputPath = await FilePicker.platform.saveFile(
          fileName: res.data['name'],
        );

        if (outputPath != null) {
          await File(outputPath).writeAsBytes(bytes);
        }
      }
      print("File saved ");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("file saved")));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                subbed = null;
                resu = null;
              }),
            },
          ),
          SizedBox(height: 20),

          selected == 1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextField(
                      controller: tc,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      onSubmitted: (value) => {sub(name!, value, 0)},
                    ),
                    SizedBox(height: 10),
                    subbed == null&&loading==false
                        ? ElevatedButton(
                            onPressed: () => sub(name!, tc.text, 0),
                            child: Text("Submit"),
                          )
                        :loading==true?CircularProgressIndicator(): InkWell(
                            onTap: () =>
                               {
                            Clipboard.setData(ClipboardData(text: subbed.toString())),ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$subbed is copied to ur clipboard")))
                          },
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Text("Your retreival code is : "),
                                SizedBox(height: 3),
                                Container(
                                  
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${subbed.toString()}"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                )
              : selected == 2
              ? Column(
                  children: [
                    InkWell(
                      onTap: () => filep(),
                      child: Container(
                        child: Text("Pick files (one at a time)"),
                      ),
                    ),
                    subbed == null
                        ? SizedBox(height: 5)
                        : InkWell(
                            onTap: () => {
                            Clipboard.setData(ClipboardData(text: subbed.toString())),ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$subbed is copied to ur clipboard")))
                          },
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Text("Your retreival code is : "),
                                SizedBox(height: 3),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${subbed}"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                )
              : Container(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TextField(
                        controller: tcr,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: (val) => retrieve(val),
                      ),
                      // Text("$resu"),
                      SizedBox(height: 20),
                      resu == null
                          ? ElevatedButton(
                              onPressed: () => {retrieve(tcr.text)},
                              child: Text("Submit"),
                            )
                          : loading == false
                          ? InkWell(onTap: () => {
                            Clipboard.setData(ClipboardData(text: resu!)),ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$resu is copied to ur clipboard")))
                          } ,child: Container(


                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(13)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("$resu!"),
                            )))
                          : CircularProgressIndicator(),
                          SizedBox(height: 10),

                      path!=null?Text(
                        "* Retrieved files will be saved at $path.....  \n It can be changed via menu",
                      ):Text("pls set file locatiion from menu",style: TextStyle(color: Colors.red),),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
