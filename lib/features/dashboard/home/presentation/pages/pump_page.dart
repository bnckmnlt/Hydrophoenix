import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydroponics_app/mqtt_service.dart';

class PumpPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const PumpPage());
  }

  const PumpPage({super.key});

  @override
  State<PumpPage> createState() => _PumpPageState();
}

class _PumpPageState extends State<PumpPage> {
  late MqttService mqttService;

  @override
  void initState() {
    super.initState();

    mqttService = GetIt.I<MqttService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Water Pump")),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.checkmark_square,
                size: 24,
              )),
        ],
      ),
    );
  }
}
