import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydroponics_app/features/dashboard/metrics/domain/entities/metrics.dart';
import 'package:intl/intl.dart'; // For date formatting

class MetricsChart extends StatefulWidget {
  final List<Metrics> data;

  const MetricsChart({
    super.key,
    required this.data,
  });

  @override
  State<MetricsChart> createState() => _MetricsChartState();
}

class _MetricsChartState extends State<MetricsChart> {
  late List<Metrics> chartData;

  List<Color> gradientColors = [
    Colors.blue,
    Colors.blueAccent,
  ];

  bool showAvg = false;

  String formatDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  @override
  void initState() {
    super.initState();

    chartData = widget.data;
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
              showAvg ? avgData() : mainData(chartData),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
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
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  // Left titles (dynamic based on min/max values)
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 14, color: Colors.white);

    // Get the max and min Y values from the data, add a fallback if empty
    double minY = widget.data.isNotEmpty
        ? widget.data
            .map((metric) => metric.value)
            .reduce((a, b) => a < b ? a : b)
        : 0.0;
    double maxY = widget.data.isNotEmpty
        ? widget.data
            .map((metric) => metric.value)
            .reduce((a, b) => a > b ? a : b)
        : 100.0; // Default to a reasonable max value

    // Calculate the range and intervals
    double range = maxY - minY;
    double interval = (range / 5).ceilToDouble();

    // If the value is at one of the intervals, display it on the axis
    if (value % interval == 0) {
      return Text(value.toStringAsFixed(0), style: style);
    } else {
      return Container(); // Hide labels in between intervals
    }
  }

  // Convert metrics to FlSpots using createdAt (timestamp) and value
  List<FlSpot> _convertMetricsToFlSpots(List<Metrics> data) {
    return data.map((metric) {
      double x =
          metric.createdAt.millisecondsSinceEpoch.toDouble(); // Use timestamp
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
        // Default fallback range
        lineBarsData: [],
      );
    }

    List<FlSpot> spots = _convertMetricsToFlSpots(data);

    // Get the max and min Y values from the data
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

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!,
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
