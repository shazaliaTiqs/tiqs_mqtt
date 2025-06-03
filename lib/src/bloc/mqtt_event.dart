// ✅ lib/src/bloc/mqtt_event.dart
abstract class MqttEvent {}

class MqttConnectRequested extends MqttEvent {}

class MqttMessageSent extends MqttEvent {
  final String topic;
  final String message;
  MqttMessageSent(this.topic, this.message);
}

class MqttMessageReceived extends MqttEvent {
  final String topic;
  final String message;
  MqttMessageReceived(this.topic, this.message);
}
