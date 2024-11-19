import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydroponics_app/core/app_secrets.dart';
import 'package:hydroponics_app/core/common/entity/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final MQTTConnStateEntity _connState = MQTTConnStateEntity();
  final MqttServerClient _client = MqttServerClient(
    AppSecrets.clusterUrl,
    '${AppSecrets.clientIdentifier ?? "defaultCluster"}-${Random().nextInt(1000000).toString().padLeft(6, '0')}',
  );
  final List<String> _topics = [
    'feedback/boxTemp',
    'feedback/boxHumidity',
    'feedback/boxPressure',
    'feedback/boxDewpoint',
    'feedback/waterLevel',
    'feedback/waterTemp',
    'feedback/pH',
    'feedback/ec',
    'feedback/tds',
    'control/waterPump',
    'control/waterPump/pump1',
    'control/waterPump/pump2',
    'control/lights',
    'control/lights/schedule',
    'control/misting',
    'control/coolingSystem',
  ];

  final StreamController<String> _temperatureController =
      StreamController<String>.broadcast();
  final StreamController<String> _humidityController =
      StreamController<String>.broadcast();
  final StreamController<String> _pressureController =
      StreamController<String>.broadcast();
  final StreamController<String> _dewpointController =
      StreamController<String>.broadcast();
  final StreamController<String> _waterCapController =
      StreamController<String>.broadcast();
  final StreamController<String> _waterTempController =
      StreamController<String>.broadcast();
  final StreamController<String> _phController =
      StreamController<String>.broadcast();
  final StreamController<String> _ecController =
      StreamController<String>.broadcast();
  final StreamController<String> _tdsController =
      StreamController<String>.broadcast();
  final StreamController<bool> _waterPumpController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _lightsController =
      StreamController<bool>.broadcast();
  final StreamController<String> _lightsScheduleController =
      StreamController<String>.broadcast();
  final StreamController<bool> _mistingController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _coolingSystemController =
      StreamController<bool>.broadcast();

  Stream<String> get temperatureStream => _temperatureController.stream;
  Stream<String> get humidityStream => _humidityController.stream;
  Stream<String> get pressureStream => _pressureController.stream;
  Stream<String> get dewpointStream => _dewpointController.stream;
  Stream<String> get waterCapStream => _waterCapController.stream;
  Stream<String> get waterTempStream => _waterTempController.stream;
  Stream<String> get phStream => _phController.stream;
  Stream<String> get ecStream => _ecController.stream;
  Stream<String> get tdsStream => _tdsController.stream;
  Stream<bool> get waterPumpStream => _waterPumpController.stream;
  Stream<bool> get lightStream => _lightsController.stream;
  Stream<String> get lightsScheduleStream => _lightsScheduleController.stream;
  Stream<bool> get mistingStream => _mistingController.stream;
  Stream<bool> get coolingSystemStream => _coolingSystemController.stream;

  void initializeMQTTClient() {
    _client.useWebSocket = true;
    _client.port = int.parse(AppSecrets.clusterPort);
    _client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    _client.logging(on: true);
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;

    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.onUnsubscribed = onUnsubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(AppSecrets.clientIdentifier)
        .authenticateAs(AppSecrets.clusterUsername.toString(),
            AppSecrets.clusterPassword.toString())
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Connecting to broker...');
    _client.connectionMessage = connMess;
  }

  Future<void> connect() async {
    initializeMQTTClient();
    try {
      print('Start client connecting....');
      _connState.setAppConnectionState(MQTTAppConnectionState.connecting);
      updateState();
      await _client.connect();
    } on Exception catch (e) {
      print('client exception - $e');
      disconnect();
    }
  }

  void onConnected() {
    _connState.setAppConnectionState(MQTTAppConnectionState.connected);
    updateState();
    subScribeToTopics();

    _client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage?>>? c) {
        final MqttPublishMessage recMessage =
            c![0].payload as MqttPublishMessage;
        final String message = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        final String topic = c[0].topic;

        print('Received message: $message from topic: $topic');

        switch (topic) {
          case 'feedback/boxTemp':
            _temperatureController.add(message);
            break;
          case 'feedback/boxHumidity':
            _humidityController.add(message);
            break;
          case 'feedback/boxPressure':
            _pressureController.add(message);
            break;
          case 'feedback/boxDewpoint':
            _dewpointController.add(message);
            break;
          case 'feedback/waterTemp':
            _waterTempController.add(message);
            break;
          case 'feedback/waterLevel':
            _waterCapController.add(message);
            break;
          case 'feedback/pH':
            _phController.add(message);
            break;
          case 'feedback/ec':
            _ecController.add(message);
            break;
          case 'feedback/tds':
            _tdsController.add(message);
            break;
          case 'control/waterPump':
            bool response = false;
            if (message == "ON") {
              response = true;
            }
            _waterPumpController.add(response);
            break;
          case 'control/lights':
            bool response = false;
            if (message == "ON") {
              response = true;
            }
            _lightsController.add(response);
            break;
          case 'control/lights/schedule':
            _lightsScheduleController.add(message);
            break;
          case 'control/misting':
            bool response = false;
            if (message == "ON") {
              response = true;
            }
            _mistingController.add(response);
            break;
          case 'control/coolingSystem':
            bool response = false;
            if (message == "ON") {
              response = true;
            }
            _coolingSystemController.add(response);
            break;
          default:
            print('Unknown topic: $topic');
        }
        notifyListeners();
      },
    );
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    _connState
        .setAppConnectionState(MQTTAppConnectionState.connectedSubscribed);
    updateState();
  }

  void onUnsubscribed(String? topic) {
    print('onUnsubscribed confirmed for topic $topic');
    _connState
        .setAppConnectionState(MQTTAppConnectionState.connectedUnsubscribed);
    updateState();
  }

  void onDisconnected() {
    print('Disconnected from the broker.');
    _connState.setAppConnectionState(MQTTAppConnectionState.disconnected);
    updateState();
  }

  void subScribeToTopics() {
    for (var topic in _topics) {
      _client.subscribe(topic, MqttQos.atLeastOnce);
      print('Subscribed to topic: $topic');
    }
  }

  void unsubScribeToTopics() {
    for (var topic in _topics) {
      _client.unsubscribe(topic);
      print('Unsubscribed to topic: $topic');
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  void updateState() {
    notifyListeners();
  }

  void publish(String topic, String message,
      {bool retain = false, MqttQos qos = MqttQos.exactlyOnce}) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client.publishMessage(topic, qos, builder.payload!, retain: retain);
    print('Message published: $message, Retained: $retain, QoS: $qos');
  }

  @override
  void dispose() {
    _temperatureController.close();
    _humidityController.close();
    _pressureController.close();
    _dewpointController.close();
    _waterCapController.close();
    _waterTempController.close();
    _phController.close();
    _ecController.close();
    _tdsController.close();
    _waterPumpController.close();
    _lightsController.close();
    _lightsScheduleController.close();
    _mistingController.close();
    _coolingSystemController.close();
    super.dispose();
  }
}
