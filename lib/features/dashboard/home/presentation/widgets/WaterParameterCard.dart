import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterParameterCard extends StatelessWidget {
  final String label;
  final IconData iconData;
  final String indicator;
  final Stream<String>? dataStream;

  const WaterParameterCard({
    super.key,
    required this.label,
    required this.iconData,
    required this.indicator,
    required this.dataStream,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
                Icon(
                  iconData,
                  size: 24,
                ),
              ],
            ),
            StreamBuilder<String>(
              stream: dataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Connecting...");
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final data = double.parse(snapshot.data!);
                  final temperature = data.toStringAsFixed(1);

                  return Text(
                    '$temperature $indicator',
                    style: GoogleFonts.phudu(
                      textStyle: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
