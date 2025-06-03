// lib/src/bloc/mqtt_state.dart
abstract class MqttState {}

class MqttInitial extends MqttState {}

class MqttConnecting extends MqttState {}

class MqttConnected extends MqttState {}

class MqttMessageState extends MqttState {
  final String topic;
  final String message;
  MqttMessageState(this.topic, this.message);
}

class MqttError extends MqttState {
  final String error;
  MqttError(this.error);
}
