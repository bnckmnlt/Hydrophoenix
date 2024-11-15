import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydroponics_app/core/common/widgets/animation.dart';
import 'package:hydroponics_app/features/details/presentation/pages/details_page.dart';
import 'package:hydroponics_app/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class QuickControls extends StatefulWidget {
  const QuickControls({super.key});

  @override
  State<QuickControls> createState() => _QuickControlsState();
}

class _QuickControlsState extends State<QuickControls>
    with AutomaticKeepAliveClientMixin {
  final MqttService mqttService = GetIt.I<MqttService>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mqttService.subScribeToTopics();
  }

  @override
  void dispose() {
    super.dispose();
    mqttService.unsubScribeToTopics();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final orientation = MediaQuery.of(context).orientation;

    final List<bool> switchValues = [false, false, false, false];

    List<Stream<bool>> controlDataStream = [
      mqttService.waterPumpStream,
      mqttService.lightStream,
      mqttService.mistingStream,
      mqttService.coolingSystemStream,
    ];

    List<String> controlLabel = [
      "Water Pump",
      "Lights",
      "Misting",
      "Cooling System"
    ];

    List<IconData> controlIcons = [
      Icons.water_drop_outlined,
      Icons.light_rounded,
      Icons.foggy,
      Icons.wind_power_rounded,
    ];

    List<MaterialColor> controlColors = [
      Colors.blue,
      Colors.orange,
      Colors.indigo,
      Colors.green,
    ];

    void toggleSwitch(int index, bool value) {
      setState(() {
        switchValues[index] = value;
      });

      const List<String> topics = [
        'control/waterPump',
        'control/lights',
        'control/misting',
        'control/coolingSystem',
      ];

      mqttService.publish(
        topics[index],
        value ? 'ON' : 'OFF',
        retain: true,
        qos: MqttQos.exactlyOnce,
      );
    }

    return BounceFromBottomAnimation(
      delay: 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quick Controls",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.025,
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Icon(
                      Icons.more_horiz_outlined,
                      size: 24,
                    ))
              ],
            ),
          ),
          // Components
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: GridView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.2,
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return BounceFromBottomAnimation(
                  delay: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, DetailsPage.route());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: controlColors[index].shade100,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Icon(
                                      controlIcons[index],
                                      color: controlColors[index],
                                      size: 28,
                                    ),
                                  ),
                                ),
                                StreamBuilder<bool>(
                                  stream: controlDataStream[index],
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Switch(
                                        value: false,
                                        onChanged: (value) {
                                          toggleSwitch(index, value);
                                        },
                                      );
                                    }

                                    final isActive = snapshot.data ?? false;

                                    return CupertinoSwitch(
                                      applyTheme: true,
                                      value: isActive,
                                      onChanged: (value) {
                                        toggleSwitch(index, value);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              controlLabel[index],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.025,
                                height: 1.2,
                              ),
                            ),
                            StreamBuilder<bool>(
                              stream: controlDataStream[index],
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    "Connecting",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceDim,
                                      fontSize: 14,
                                      letterSpacing: 0.025,
                                    ),
                                  );
                                }

                                final isActive = snapshot.data ?? false;

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 10.0,
                                      width: 10.0,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.greenAccent.shade400
                                            : Colors.redAccent,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isActive ? "Running" : "Inactive",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceDim,
                                        fontSize: 14,
                                        letterSpacing: 0.025,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
