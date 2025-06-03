import 'package:flutter_bloc/flutter_bloc.dart';
import '../../tiqs_mqtt.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  final MqttRepository repository;

  MqttBloc(this.repository) : super(MqttInitial()) {
    on<MqttConnectRequested>(_onConnect);
    on<MqttMessageSent>(_onSendMessage);
    on<MqttMessageReceived>(_onMessageReceived);
  }

  Future<void> _onConnect(
      MqttConnectRequested event, Emitter<MqttState> emit) async {
    emit(MqttConnecting());
    await repository.connect();
    emit(MqttConnected());
  }

  void _onSendMessage(MqttMessageSent event, Emitter<MqttState> emit) {
    repository.send(event.message);
  }

  void _onMessageReceived(MqttMessageReceived event, Emitter<MqttState> emit) {
    emit(MqttMessageState(event.topic, event.message));
  }
}
