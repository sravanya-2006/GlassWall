import 'dart:io';
import 'services/discovery_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  String? name;
  List<String> recfiles = [];
  HttpServer? server;
  Directory? dir;
  final DiscoveryService discovery = DiscoveryService();

  @override
  void initState() {
    super.initState();
    ser();
    startreg();
  }

  Future<void> startreg() async {
    print("assta lavista baby");

    try {
      print("psuhhhh");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //  prefs.clear();
      name = prefs.getString("name");

      await discovery.startReceiver(
        deviceName: name ?? "Unknown Device",
        port: 6969,
      );

      print("UDP broadcaster started");

      if (!mounted) {
        print("not mounted");
        return;
      }
      ;

      print("ahh bro im visible now!!!!!!!!!!!!!!!!!!");
    } catch (e, st) {
      print("error $e");
      print("error $st");
    }
  }

  Future<void> ser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? loc = pref.getString("chosen");

    try {
      server = await HttpServer.bind(InternetAddress.anyIPv4, 6969);
      print("server is up");
      server!.listen((HttpRequest req) async {
        print("REQUEST RECEIVED: ${req.uri.path}");

        if (req.uri.path == '/wannarecieve') {
          print("TRANSFER REQUEST RECEIVED");
          print("Filename: ${req.headers.value('filename')}");
          print("Sender: ${req.headers.value('myself')}");

          String fname =
              req.headers.value('filename') ??
              'Whats in the box !!! Whats in the boxxx ';
          String hisname = req.headers.value('myself')!;

          bool? accepted = await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text("${hisname} wants to send u something  "),
              content: Text(
                "Total count : ${req.headers.value('count')} \n $fname ",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: Text("Reject"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: Text("Accept"),
                ),
              ],
            ),
          );
          if (accepted!) {
            req.response
              ..statusCode = 200
              ..close();
          } else {
            req.response
              ..statusCode = 403
              ..close();
          }
        } else if (req.uri.path == '/Enjoy') {
          String fname =
              req.headers.value('filename') ??
              'Whats in the box !!! Whats in the boxxx ';
          if (loc == null) {
            dir = await getApplicationDocumentsDirectory();
          } else {
            dir = await Directory(loc!);
          }

          File file = File('${dir!.path}/$fname');
          IOSink sink = file.openWrite();
          await req.cast<List<int>>().pipe(sink);
          await sink.close();

          req.response
            ..statusCode = 200
            ..close();
          if (mounted) {
            recfiles.add(file.path);
            print("Files recieved");
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    discovery.dispose();
    server?.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    bool isd = Theme.of(context).brightness == Brightness.dark;
    var sw = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LinearProgressIndicator(),
          // CircularProgressIndicator(),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Text("Hello, ")),
                Flexible(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (b) => RadialGradient(
                      colors: isd
                          ? [Colors.blue, Color(0xFFF5F5DC)]
                          : [
                              Color(0xFF00E5FF),
                              Color(0xFF0052D4),
                              Color(0xFF090A0F),
                            ],
                      center: AlignmentGeometry.bottomRight,
                      radius: 4,
                    ).createShader(b),

                    child: Text(
                      "$name !",
                      style: TextStyle(
                        // fontWeight: FontWeight.w400,
                        // fontSize: sw*0.04,
                        fontFamily: 'opensauce',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 16),
          Flexible(
            flex: 4,
            child: LottieBuilder.asset("ass/sleep.json", fit: BoxFit.cover),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Waiting for senders...   ")],
            ),
          ),
        ],
      ),
    );
  }
}
