import 'package:flutter/material.dart';
import 'package:hydroponics_app/features/dashboard/metrics/presentation/widgets/DataChartCard.dart';

List<Map<String, Color>> chamberLabels = [
  {
    "Temperature": Colors.blueAccent,
    "Humidity": Colors.lightBlueAccent,
  },
  {
    "Pressure": Colors.redAccent,
  },
  {
    "Dewpoint": Colors.greenAccent,
  },
];

List<String> chamberSections = [
  "Temperature and Humidity",
  "Pressure",
  "Dewpoint"
];

List<Map<String, Color>> reservoirLabels = [
  {
    "Water Temperature": Colors.blueAccent,
  },
  {
    "Water Level": Colors.blueGrey,
  },
];

List<String> reservoirSections = [
  "Reservoir Temperature",
  "Reservoir Level",
];

class MetricsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => MetricsPage());

  const MetricsPage({super.key});

  @override
  State<MetricsPage> createState() => _MetricsPageState();
}

class _MetricsPageState extends State<MetricsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Metrics",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.025,
                  ),
                ),
                const SizedBox(height: 24),
                DataChartCard(
                  title: "Chamber",
                  labels: chamberLabels,
                  sections: chamberSections,
                ),

                const SizedBox(height: 24),
                DataChartCard(
                  title: "Reservoir",
                  labels: reservoirLabels,
                  sections: reservoirSections,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
