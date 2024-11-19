import 'package:flutter/material.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';
import 'package:hydroponics_app/features/dashboard/metrics/presentation/widgets/MetricsChart.dart';

class DataChartCard extends StatefulWidget {
  final String title;
  final List<Map<String, Color>> labels;
  final List<String> sections;
  final List<List<Metrics>> readingsData;
  final List<List<Color>> chartColors;

  const DataChartCard({
    super.key,
    required this.title,
    required this.labels,
    required this.sections,
    required this.readingsData,
    required this.chartColors,
  });

  @override
  State<DataChartCard> createState() => _DataChartCardState();
}

class _DataChartCardState extends State<DataChartCard> {
  late String title;
  late List<Map<String, Color>> labels;
  late List<String> sections;
  late List<List<Metrics>> readingsData;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    labels = widget.labels;
    sections = widget.sections;
    readingsData = widget.readingsData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title Overview",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.025,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Text(
                "$title statistics for the day",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  fontSize: 16,
                  letterSpacing: 0.025,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...sections.asMap().entries.map((entry) {
              int index = entry.key;
              String section = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  parameterSection(
                    section,
                    labels[index],
                    readingsData[index],
                    widget.chartColors[index],
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget parameterSection(String title, Map<String, Color> labelItems,
      List<Metrics> data, List<Color> gradientColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 13,
              width: 27,
              decoration: BoxDecoration(
                color: labelItems.values.first,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.025,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (data.isEmpty) const Center(child: CircularProgressIndicator()),
        if (data.isNotEmpty)
          MetricsChart(
            data: data,
            gradientColors: gradientColors,
          ),
      ],
    );
  }
}
