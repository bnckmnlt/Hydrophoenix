import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydroponics_app/core/common/loader.dart';
import 'package:hydroponics_app/core/utils/show_snackbar.dart';
import 'package:hydroponics_app/features/dashboard/home/presentation/widgets/CustomBG.dart';
import 'package:hydroponics_app/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class LightsPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(builder: (context) => const LightsPage());
  }

  const LightsPage({super.key});

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  late StreamSubscription<String> _lightsScheduleSubscription;
  late MqttService mqttService;

  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  void initState() {
    super.initState();

    mqttService = GetIt.I<MqttService>();
    mqttService.connect();

    _startTime = const TimeOfDay(hour: 0, minute: 0);
    _endTime = const TimeOfDay(hour: 0, minute: 0);

    _lightsScheduleSubscription =
        mqttService.lightsScheduleStream.listen((payload) {
      final times = payload.split(':');
      if (times.length == 4) {
        setState(() {
          _startTime =
              TimeOfDay(hour: int.parse(times[0]), minute: int.parse(times[1]));
          _endTime =
              TimeOfDay(hour: int.parse(times[2]), minute: int.parse(times[3]));
        });
      }
    });
  }

  @override
  void dispose() {
    _lightsScheduleSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Growing Lights")),
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
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: const Text("Hello world"),
                ),
                const SizedBox(height: 64),
                animatedToggle(),
                const SizedBox(height: 24),
                Text(
                  "Device",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceDim,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Grow LED Light 100W",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.rubik.toString(),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 54),
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
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 12),
                            child: Text(
                              "Grow Light Schedule",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Start time",
                                  style: TextStyle(
                                    fontFamily: "Red Hat Mono",
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: _startTime,
                                    ).then((pickedTime) {
                                      if (pickedTime != null) {
                                        setState(() {
                                          _startTime = pickedTime;
                                        });
                                      }
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.sunny,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            _formatTimeOfDay(_startTime),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24,
                                              letterSpacing: 0.025,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "End time",
                                  style: TextStyle(
                                    fontFamily: "Red Hat Mono",
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: _endTime,
                                    ).then((pickedTime) {
                                      if (pickedTime != null) {
                                        setState(() {
                                          _endTime = pickedTime;
                                        });
                                      }
                                    });
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.nightlight,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _formatTimeOfDay(_endTime),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24,
                                          letterSpacing: 0.025,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 46),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text("Reset Schedule"),
                                      content: Text(
                                        'Do you want to reset the light schedule configuration for your system?',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceDim,
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (result == 'OK') {
                                    mqttService.publish(
                                        "control/lights/schedule",
                                        "05:00:18:00",
                                        qos: MqttQos.exactlyOnce,
                                        retain: true);

                                    context.showSnackBar(
                                        message:
                                            "Light schedule returned to default configuration");
                                  }
                                },
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                  onPressed: () async {
                                    int startMinutes = _startTime.hour * 60 +
                                        _startTime.minute;
                                    int endMinutes =
                                        _endTime.hour * 60 + _endTime.minute;

                                    if (endMinutes <= startMinutes) {
                                      endMinutes += 24 * 60;
                                    }

                                    int duration = endMinutes - startMinutes;

                                    if (duration < 12 * 60) {
                                      context.showErrorSnackBar(
                                          message:
                                              "The light schedule must be at least 12 hours. Please adjust the start and end times.");
                                      return;
                                    }

                                    final result = await showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title:
                                            const Text("Save Light Schedule"),
                                        content: Text(
                                          'Do you want to save this light schedule configuration for the system?',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceDim,
                                            fontSize: 16,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result == 'OK') {
                                      mqttService.publish(
                                          "control/lights/schedule",
                                          "${_formatTimeOfDay(_startTime)}:${_formatTimeOfDay(_endTime)}",
                                          qos: MqttQos.exactlyOnce,
                                          retain: true);

                                      context.showSnackBar(
                                          message:
                                              "Successfully changed the light schedule");
                                    }
                                  },
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

  Widget animatedToggle() {
    return StreamBuilder<bool>(
        stream: mqttService.lightStream,
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
                  "control/lights",
                  isToggledOn ? "OFF" : "ON",
                  retain: true,
                );

                context.showSnackBar(
                    message:
                        "Grow Lights turned ${isToggledOn ? 'OFF' : 'ON'}");
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
                                "Growing",
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
                                "Lights",
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
