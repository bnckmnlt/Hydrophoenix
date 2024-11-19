import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/AnimatedToggleButton.dart';
import 'package:hydroponics_app/mqtt_service.dart';

class MistingPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const MistingPage());
  }

  const MistingPage({super.key});

  @override
  State<MistingPage> createState() => _MistingPageState();
}

class _MistingPageState extends State<MistingPage> {
  late MqttService mqttService;

  @override
  void initState() {
    super.initState();

    mqttService = GetIt.I<MqttService>();
    mqttService.connect();
  }

  double _temperatureTarget = 21;
  double _humidityTarget = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Misting")),
        actions: const [
          SizedBox(
            height: 58,
            width: 58,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StreamBuilder<bool>(
                            stream: mqttService.mistingStream,
                            builder: (context, snapshot) {
                              final isToggledOn = snapshot.data ?? false;

                              return Icon(
                                CupertinoIcons.snow,
                                color: isToggledOn
                                    ? Colors.greenAccent.shade400
                                    : Colors.redAccent,
                                size: 24,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "76 %",
                            style: TextStyle(
                              fontFamily: "Red Hat Mono",
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                AnimatedToggleButton(
                  streamReading: mqttService.mistingStream,
                  topic: "control/misting",
                  label: "Misting",
                  deviceTitle1: "Misting",
                  deviceTitle2: "Device",
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Text(
                      "Humidity",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<String>(
                      stream: mqttService.humidityStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            "Connecting...",
                            style: TextStyle(
                              fontFamily: GoogleFonts.rubik.toString(),
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(
                              '${snapshot.error}',
                              style: TextStyle(
                                fontFamily: GoogleFonts.rubik.toString(),
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final humidity = double.parse(snapshot.data!);

                          return Text(
                            '$humidity %',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: GoogleFonts.rubik.toString(),
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          );
                        } else {
                          return Text(
                            'No data available',
                            style: TextStyle(
                              fontFamily: GoogleFonts.rubik.toString(),
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 44),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 12),
                            child: Text(
                              "Humidity Target",
                              style: TextStyle(
                                fontFamily: "Red Hat Mono",
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.snow,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 32,
                              ),
                              Expanded(
                                child: Slider(
                                  value: _humidityTarget,
                                  min: 40.0,
                                  max: 60.0,
                                  divisions: 15,
                                  label: "${_humidityTarget.round()}°C",
                                  onChanged: (double value) {
                                    setState(() {
                                      _humidityTarget = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                child: Icon(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  Icons.refresh_rounded,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {},
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Text(
                                    "Save changes",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 18,
                                      letterSpacing: 0.025,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
