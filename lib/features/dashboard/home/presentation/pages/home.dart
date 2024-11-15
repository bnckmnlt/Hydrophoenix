import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:hydroponics_app/core/common/widgets/animation.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/BoxConditionCard.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/QuickControls.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/ReservoirParameterCard.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/WaterParameterCard.dart';
import 'package:hydroponics_app/mqtt_service.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (builder) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  List<bool> isSelected = [true, false, false];
  late MqttService mqttService;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mqttService = GetIt.I<MqttService>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ["Live", "Weekly", "Monthly"]
                      .asMap()
                      .entries
                      .map(
                        (entry) => GestureDetector(
                          onTap: () {
                            setState(() {
                              for (int i = 0; i < isSelected.length; i++) {
                                isSelected[i] = i == entry.key;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isSelected[entry.key]
                                      ? Colors.blueAccent.shade400
                                      : Theme.of(context).colorScheme.outline,
                                ),
                                color: isSelected[entry.key]
                                    ? Colors.blueAccent.shade400
                                    : Colors.transparent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 32.0,
                                ),
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.025,
                                    fontSize: 16.0,
                                    color: isSelected[entry.key]
                                        ? Theme.of(context).colorScheme.surface
                                        : Theme.of(context)
                                            .colorScheme
                                            .surfaceDim,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              getSelectedView(
                mqttService,
              ),
              QuickControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSelectedView(MqttService mqttService) {
    if (isSelected[0]) {
      return SizedBox(
        height: 748,
        width: double.infinity,
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 14,
          children: [
            BounceFromBottomAnimation(
              delay: 0.5,
              child: BoxConditionCard(
                tempDataStream: mqttService.temperatureStream,
                humidityDataStream: mqttService.humidityStream,
                pressureDataStream: mqttService.pressureStream,
              ),
            ),
            BounceFromBottomAnimation(
              delay: 0.5,
              child: ReservoirParameterCard(
                waterTempDataStream: mqttService.waterTempStream,
                waterLevelDataStream: mqttService.waterCapStream,
              ),
            ),
            BounceFromBottomAnimation(
              delay: 1,
              child: WaterParameterCard(
                label: "pH",
                iconData: FluentIcons.heart_24_regular,
                indicator: "",
                dataStream: mqttService.phStream,
              ),
            ),
            BounceFromBottomAnimation(
              delay: 1,
              child: WaterParameterCard(
                label: "Dewpoint",
                iconData: FluentIcons.weather_fog_24_regular,
                indicator: "°C",
                dataStream: mqttService.dewpointStream,
              ),
            ),
            BounceFromBottomAnimation(
              delay: 1.5,
              child: WaterParameterCard(
                label: "TDS",
                iconData: FluentIcons.water_24_regular,
                indicator: "ppm",
                dataStream: mqttService.tdsStream,
              ),
            ),
            BounceFromBottomAnimation(
              delay: 1.5,
              child: WaterParameterCard(
                label: "EC",
                iconData: FluentIcons.lightbulb_24_regular,
                indicator: "mS/cm",
                dataStream: mqttService.ecStream,
              ),
            ),
          ],
        ),
      );
    } else if (isSelected[1]) {
      return Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.green.shade100,
        child: Text("Weekly View", style: TextStyle(fontSize: 24)),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.orange.shade100,
        child: Text("Monthly View", style: TextStyle(fontSize: 24)),
      );
    }
  }
}
