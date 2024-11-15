import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxConditionCard extends StatelessWidget {
  final Stream<String>? tempDataStream;
  final Stream<String>? humidityDataStream;
  final Stream<String>? pressureDataStream;

  BoxConditionCard({
    super.key,
    required this.tempDataStream,
    required this.humidityDataStream,
    required this.pressureDataStream,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Chamber Condition",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Temperature",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    Icon(
                      FluentIcons.temperature_24_regular,
                      size: 24,
                      color: Theme.of(context).colorScheme.surfaceDim,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StreamBuilder<String>(
                    stream: tempDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text("Connecting..."),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = double.parse(snapshot.data!);
                        final temperature = data;

                        return Text(
                          '$temperature °C',
                          style: GoogleFonts.phudu(
                            textStyle: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Humidity",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    Icon(
                      FluentIcons.drop_24_regular,
                      size: 20,
                      color: Theme.of(context).colorScheme.surfaceDim,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StreamBuilder<String>(
                    stream: humidityDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text("Connecting..."),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = double.parse(snapshot.data!);
                        final temperature = data;

                        return Text(
                          '$temperature %',
                          style: GoogleFonts.phudu(
                            textStyle: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pressure",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                    Icon(
                      FluentIcons.gauge_24_regular,
                      size: 20,
                      color: Theme.of(context).colorScheme.surfaceDim,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StreamBuilder<String>(
                    stream: pressureDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text("Connecting..."),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final data = double.parse(snapshot.data!);
                        final temperature = data.toStringAsFixed(1);

                        return Text(
                          '$temperature hPa',
                          style: GoogleFonts.phudu(
                            textStyle: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
