import 'package:flutter/material.dart';

class Constants {
  static const List<Map<String, MaterialAccentColor>> chamberLabels = [
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

  static const List<Map<String, Color>> reservoirLabels = [
    {
      "Water Temperature": Colors.blueAccent,
    },
    {
      "Water Level": Colors.blueGrey,
    },
  ];

  static const List<Map<String, Color>> sensorLabels = [
    {
      "pH Level": Colors.yellow,
    },
    {
      "EC Level": Colors.indigo,
    },
    {
      "TDS Level": Colors.orange,
    },
  ];

  static const List<List<Color>> chartChamberColors = [
    [Colors.blue, Colors.blueAccent],
    [Colors.lightBlue, Colors.lightBlueAccent],
    [Colors.red, Colors.redAccent],
    [Colors.green, Colors.greenAccent],
  ];

  static List<List<Color>> chartWaterColors = [
    [Colors.blue, Colors.blueAccent],
    [Colors.blueGrey, Colors.blueGrey.withOpacity(0.5)],
  ];

  static const List<List<Color>> chartSensorColors = [
    [Colors.yellow, Colors.yellowAccent],
    [Colors.indigo, Colors.indigoAccent],
    [Colors.orange, Colors.orangeAccent],
  ];

  static const List<String> chamberSections = [
    "Temperature",
    "Humidity",
    "Pressure",
    "Dewpoint"
  ];

  static const List<String> reservoirSections = [
    "Reservoir Temperature",
    "Reservoir Level",
  ];

  static const List<String> sensorSections = [
    "pH",
    "EC",
    "TDS",
  ];
}
