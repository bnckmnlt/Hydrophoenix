import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class ReservoirParameterCard extends StatelessWidget {
  final Stream<String>? waterTempDataStream;
  final Stream<String>? waterLevelDataStream;

  const ReservoirParameterCard({
    super.key,
    required this.waterTempDataStream,
    required this.waterLevelDataStream,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 150,
          width: double.infinity,
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
                  "Water\nTemperature",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                StreamBuilder<String>(
                  stream: waterTempDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Connecting...");
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          height: 233,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: StreamBuilder<String>(
                  stream: waterLevelDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      double currentCapacity =
                          double.tryParse(snapshot.data!) ?? 0;

                      return LiquidLinearProgressIndicator(
                        value: (currentCapacity) / 34,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.lightBlueAccent.shade100,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        borderColor: Colors.transparent,
                        borderWidth: 5.0,
                        borderRadius: 12.0,
                        direction: Axis.vertical,
                        center: Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Capacity",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surfaceDim,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.8,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  StreamBuilder<String>(
                                    stream: waterLevelDataStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                          "0",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                            letterSpacing: 0.025,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {
                                        final data =
                                            double.parse(snapshot.data!);
                                        final temperature = data;

                                        return Text(
                                          '${temperature.toStringAsFixed(2)}',
                                          style: GoogleFonts.phudu(
                                            textStyle: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w500,
                                              height: 1,
                                              letterSpacing: 0.025,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Text('No data available');
                                      }
                                    },
                                  ),
                                  Text(
                                    "/",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceDim,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                    ),
                                  ),
                                  Text(
                                    "34L",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceDim,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return LiquidLinearProgressIndicator(
                        value: 0,
                        valueColor: AlwaysStoppedAnimation(
                          Colors.lightBlueAccent.shade100,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        borderColor: Colors.transparent,
                        borderWidth: 5.0,
                        borderRadius: 12.0,
                        direction: Axis.vertical,
                        center: Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Capacity",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surfaceDim,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.8,
                                ),
                              ),
                              Text(
                                "No data available",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surfaceDim,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const Positioned(
                top: 20,
                left: 20,
                child: Text(
                  "Reservoir",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
