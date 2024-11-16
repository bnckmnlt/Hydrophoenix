import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydroponics_app/features/dashboard/metrics/presentation/bloc/metrics_bloc.dart';
import 'package:hydroponics_app/features/dashboard/metrics/presentation/widgets/DataChartCard.dart';

List<Map<String, Color>> chamberLabels = [
  {
    "Temperature": Colors.blueAccent,
  },
  {
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
  "Temperature",
  "Humidity",
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
  void initState() {
    super.initState();

    final bloc = context.read<MetricsBloc>();
    bloc.add(MetricsFetchMetrics(tables: const [
      "box_dewpoint",
      "box_humidity",
      "box_pressure",
      "box_temperature",
      "water_temperature",
      "water_level"
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<MetricsBloc, MetricsState>(
              builder: (context, state) {
                if (state is MetricsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MetricsDisplaySuccess) {
                  final combinedMetrics = state.combinedMetrics;

                  if (combinedMetrics.isEmpty) {
                    return const Center(child: Text("No Data Available"));
                  }

                  return Column(
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
                        readingsData: [
                          combinedMetrics["box_temperature"] ?? [],
                          combinedMetrics["box_humidity"] ?? [],
                          combinedMetrics["box_pressure"] ?? [],
                          combinedMetrics['box_dewpoint'] ?? [],
                        ],
                      ),
                      const SizedBox(height: 24),
                      DataChartCard(
                        title: "Reservoir",
                        labels: reservoirLabels,
                        sections: reservoirSections,
                        readingsData: [
                          combinedMetrics["water_temperature"] ?? [],
                          combinedMetrics["water_level"] ?? [],
                        ],
                      ),
                    ],
                  );
                }

                if (state is MetricsFailure) {
                  return Center(child: Text("Error: ${state.message}"));
                }

                return const Center(child: Text("No Data Available"));
              },
            ),
          ),
        ),
      ),
    );
  }
}
