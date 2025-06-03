// lib/src/repository/mqtt_repository.dart
import '../service/mqtt_service.dart';

class MqttRepository {
  final MQTTService service;

  MqttRepository({
    required String host,
    required int port,
    required String vendorId,
    required String employeeId,
    required String clientId,
    required String username,
    required String password,
    required void Function(String message) onMessageReceived,
  }) : service = MQTTService(
          host: host,
          port: port,
          vendorId: vendorId,
          employeeId: employeeId,
          clientId: clientId,
          username: username,
          password: password,
          onMessageReceived: onMessageReceived,
        ) {
    service.initialize();
  }

  Future<void> connect() => service.connect();

  void disconnect() => service.disconnect();

  void send(String message, {String? customTopic}) =>
      service.publish(message, customTopic: customTopic);
}
