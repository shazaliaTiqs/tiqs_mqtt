// lib/tiqs_mqtt.dart
library tiqs_mqtt;

// lib/src/service/mqtt_service.dart
import 'dart:developer';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MQTTService({
    required this.host,
    required this.port,
    required this.vendorId,
    required this.employeeId,
    required this.clientId,
    required this.username,
    required this.password,
    required this.onMessageReceived,
  });

  final String host;
  final int port;
  final String vendorId;
  final String employeeId;
  final String clientId;
  final String username;
  final String password;
  final void Function(String message) onMessageReceived;

  late MqttServerClient _client;
  late String _topic;

  void initialize() {
    _topic = 'tiqs/$vendorId/$employeeId';

    _client = MqttServerClient(host, clientId)
      ..port = port
      ..logging(on: false)
      ..onDisconnected = _onDisconnected
      ..onSubscribed = _onSubscribed
      ..onConnected = _onConnected
      ..keepAlivePeriod = 20;

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(username, password)
        .withWillTopic('TIQS/$vendorId/$clientId/will')
        .withWillMessage('Client disconnected unexpectedly')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
  }

  Future<void> connect() async {
    try {
      await _client.connect();
    } catch (e) {
      log('Connection failed: \$e');
      _client.disconnect();
    }
  }

  void disconnect() {
    try {
      _client.disconnect();
    } catch (e) {
      log('Disconnect failed: \$e');
    }
  }

  void _onConnected() {
    log('✅ Connected to MQTT Broker');
    try {
      _client.subscribe(_topic, MqttQos.atLeastOnce);
      _client.updates!.listen((events) {
        final recMess = events[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
        onMessageReceived(payload);
      });
    } catch (e) {
      log('Error on message receive: \$e');
    }
  }

  void _onDisconnected() {
    log('🔌 Disconnected from MQTT Broker');
  }

  void _onSubscribed(String topic) {
    log('📡 Subscribed to: \$topic');
  }

  void publish(String message, {String? customTopic}) {
    final topicToUse = customTopic ?? _topic;
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topicToUse, MqttQos.atLeastOnce, builder.payload!);
  }
}
