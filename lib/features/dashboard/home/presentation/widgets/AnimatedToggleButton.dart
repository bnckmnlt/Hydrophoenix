import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydroponics_app/core/common/loader.dart';
import 'package:hydroponics_app/core/utils/show_snackbar.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/CustomBG.dart';
import 'package:hydroponics_app/mqtt_service.dart';

class AnimatedToggleButton extends StatelessWidget {
  final Stream<bool> streamReading;
  final String topic;
  final String label;
  final String deviceTitle1;
  final String deviceTitle2;

  const AnimatedToggleButton({
    super.key,
    required this.streamReading,
    required this.topic,
    required this.label,
    required this.deviceTitle1,
    required this.deviceTitle2,
  });

  @override
  Widget build(BuildContext context) {
    MqttService mqttService = GetIt.I<MqttService>();

    return StreamBuilder<bool>(
        stream: streamReading,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          final isToggledOn = snapshot.data ?? false;

          return CustomPaint(
            painter: CustomBG(isDefault: isToggledOn),
            child: MaterialButton(
              onPressed: () {
                mqttService.publish(
                  topic,
                  isToggledOn ? "OFF" : "ON",
                  retain: true,
                );

                context.showSnackBar(
                    message: "$label turned ${isToggledOn ? 'OFF' : 'ON'}");
              },
              shape: CircleBorder(
                side: BorderSide(
                  color: isToggledOn ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
              child: Container(
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isToggledOn ? Colors.greenAccent : Colors.redAccent,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.75),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Center(
                            child: Text(
                              isToggledOn ? "Active" : "Inactive",
                              style: GoogleFonts.rubik(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 48,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.025,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isToggledOn ? 0.75 : 0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                deviceTitle1,
                                style: TextStyle(
                                  fontFamily: "Red Hat Mono",
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                deviceTitle2,
                                style: TextStyle(
                                  fontFamily: "Red Hat Mono",
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
        });
  }
}
