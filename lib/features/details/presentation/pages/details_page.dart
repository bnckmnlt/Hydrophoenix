import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (builder) => const DetailsPage());

  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
      ),
      body: const Text("Details"),
    );
  }
}
