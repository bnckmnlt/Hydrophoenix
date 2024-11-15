import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => SetupPage());

  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}