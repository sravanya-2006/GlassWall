import 'package:flutter/material.dart';
import 'package:nsd/nsd.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Discovery? dis;
  List<Service> senders = [];

  @override
  void initState() {
    super.initState();
    startdis();
  }

  Future<void> startdis() async {
    dis = await startDiscovery('_OnlyFiles._tcp');
    dis!.addServiceListener((guys, status) {
      if (!mounted) return;
      setState(() {
        if (status == ServiceStatus.found) {
          if (!senders.any((i) => i.host == guys.host && i.port == guys.port)) {
            senders.add(guys);
          }
        } else if (status == ServiceStatus.lost) {
          senders.removeWhere((i) => i.host == guys.host && i.port == guys.port);
        }
      });
    });
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