import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:nsd/nsd.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Discovery? dis ;
  List<Service> recievers = [];
  void initState(){
    super.initState();
    startdis();
    print("Reciver page on");

  }
  Future<void> startdis() async{
      

    dis = await startDiscovery('_OnlyFiles._tcp');
    dis!.addServiceListener((guys,status){
      setState(() {
        recievers.clear();
        if(status==ServiceStatus.found){
          if(!mounted)return;
          print(guys.name);
          if(!recievers.any((i)=>i.name==guys.name)){
          recievers.add(guys);
        }
        }
        else if(status== ServiceStatus.lost){
          recievers.removeWhere((i)=>i.name==guys.name);
        }
      });
    });
  }
  void dispose(){
  if(dis!=null)stopDiscovery(dis!);
  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   return recievers.isEmpty?Center(child: Text("no recievers yet")):ListView.builder(itemCount: recievers.length,itemBuilder: (context,i)=>ListTile(
    title: Text(recievers[i].name??'analymous'),
    subtitle: Text('${recievers[i].host}:${recievers[i].port}'),
   ));
  }
}