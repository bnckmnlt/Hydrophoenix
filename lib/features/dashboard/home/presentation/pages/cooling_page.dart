import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoolingPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const CoolingPage());
  }

  const CoolingPage({super.key});

  @override
  State<CoolingPage> createState() => _CoolingPageState();
}

class _CoolingPageState extends State<CoolingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Cooling System")),
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
