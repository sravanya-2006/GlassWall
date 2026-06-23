import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'device.dart';

class DiscoveryService {
  RawDatagramSocket? socket;
  Timer? broadcaster;

  final List<Device> devices = [];

  Future<void> startReceiver({
    required String deviceName,
    int port = 6969,
  }) async {
    broadcaster = Timer.periodic(const Duration(seconds: 2), (_) async {
      final sender = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      sender.broadcastEnabled = true;

      final data = jsonEncode({"name": deviceName, "port": port});

      sender.send(utf8.encode(data), InternetAddress("255.255.255.255"), 8888);

      sender.close();
    });
  }

  Future<void> startSender({required Function(Device) onDeviceFound}) async {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);

    socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = socket!.receive();

        if (dg == null) return;

        final msg = utf8.decode(dg.data);

        try {
          final json = jsonDecode(msg);

          final device = Device(
            name: json["name"],
            ip: dg.address.address,
            port: json["port"],
          );

          onDeviceFound(device);
        } catch (_) {}
      }
    });
  }

  void dispose() {
    socket?.close();
    broadcaster?.cancel();
  }
}
