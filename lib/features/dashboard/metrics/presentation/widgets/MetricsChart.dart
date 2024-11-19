import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';
import 'package:intl/intl.dart'; // For date formatting

class MetricsChart extends StatefulWidget {
  final List<Metrics> data;
  final List<Color> gradientColors;

  const MetricsChart({
    super.key,
    required this.data,
    required this.gradientColors,
  });

  @override
  State<MetricsChart> createState() => _MetricsChartState();
}

class _MetricsChartState extends State<MetricsChart> {
  late List<Metrics> chartData;
  late List<Color> gradientColors;

  bool showAvg = false;

  String formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  @override
  void initState() {
    super.initState();
    chartData = widget.data;
    gradientColors = widget.gradientColors;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 0,
              left: 0,
              top: 14,
              bottom: 12,
            ),
            child: LineChart(
              mainData(chartData),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final String formattedDate = formatDate(date);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        formattedDate,
        style: TextStyle(
            fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style =
        TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface);

    double minY = chartData.isNotEmpty
        ? chartData
            .map((metric) => metric.value)
            .reduce((a, b) => a < b ? a : b)
        : 0.0;
    double maxY = chartData.isNotEmpty
        ? chartData
            .map((metric) => metric.value)
            .reduce((a, b) => a > b ? a : b)
        : 100.0;

    double range = maxY - minY;
    double interval = (range / 5).ceilToDouble();

    if (value % interval == 0) {
      return Text(value.toStringAsFixed(0), style: style);
    } else {
      return Container();
    }
  }

  List<FlSpot> _convertMetricsToFlSpots(List<Metrics> data) {
    return data.map((metric) {
      double x = metric.createdAt.millisecondsSinceEpoch.toDouble();
      double y = metric.value;

      return FlSpot(x, y);
    }).toList();
  }

  LineChartData mainData(List<Metrics> data) {
    if (data.isEmpty) {
      return LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 1,
        minY: 0,
        maxY: 100,
        lineBarsData: [],
      );
    }

    List<FlSpot> spots = _convertMetricsToFlSpots(data);

    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 32,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      ),
      minX: spots.isEmpty ? 0 : spots.first.x,
      maxX: spots.isEmpty ? 11 : spots.last.x,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
