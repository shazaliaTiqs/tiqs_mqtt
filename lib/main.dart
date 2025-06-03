import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiqs_mqtt/test/mqtt_test.dart';
import 'tiqs_mqtt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MqttBloc _bloc;

  @override
  void initState() {
    super.initState();
//TIQS HOST : 87.233.96.146
    // FREE HOST: 'broker.hivemq.com',
    final repository = MqttRepository(
      host: 'broker.hivemq.com',
      port: 1883,
      vendorId: 'vendor123',
      employeeId: 'employee456',
      clientId: 'tiqs-client',
      username: 'guest',
      password: 'guest',
      onMessageReceived: (msg) {
        _bloc.add(MqttMessageReceived('tiqs/vendor123/employee456', msg));
      },
    );
    _bloc = MqttBloc(repository);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => _bloc,
        child: const MqttTestScreen(),
      ),
    );
  }
}
