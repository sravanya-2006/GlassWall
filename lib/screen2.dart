import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Discovery? dis;
  List<Service> senders = [];
  String? name;
  Registration ? reg;
  bool isreg = false;

  @override
  void initState() {
    super.initState();
    startreg();
  
  }

  Future<void> startreg()async{
     print("assta lavista baby");
   
   try{
     print("psuhhhh");
     SharedPreferences prefs = await SharedPreferences.getInstance();
    //  prefs.clear();
     name = prefs.getString("name");
     reg = await register(Service(
      name: '$name',
      type: '_pandawannashare._tcp',
      port: 6969,
    ));
    if(!mounted){
      print("not mounted");
      return;};
    setState(() {
      isreg = true;
    });
    print("ahh bro im visible now!!!!!!!!!!!!!!!!!!");
   }
   catch(e,st){
    print("error $e");
    print("error $st");
   }
  }


  @override
  void dispose() {
    if (dis != null) stopDiscovery(dis!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return senders.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Scanning for senders..."),
              ],
            ),
          )
        : ListView.builder(
            itemCount: senders.length,
            itemBuilder: (ctx, i) => ListTile(
              leading: Icon(Icons.phone_android),
              title: Text(senders[i].name ?? 'Unknown'),
              subtitle: Text('${senders[i].host}:${senders[i].port}'),
              onTap: () {
                // → connect + receive file here
              },
            ),
          );
  }
}