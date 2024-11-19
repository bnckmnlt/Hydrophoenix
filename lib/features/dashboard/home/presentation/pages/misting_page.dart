import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MistingPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const MistingPage());
  }

  const MistingPage({super.key});

  @override
  State<MistingPage> createState() => _MistingPageState();
}

class _MistingPageState extends State<MistingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Misting")),
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
