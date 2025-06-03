import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiqs_mqtt/tiqs_mqtt.dart';

class MqttTestScreen extends StatelessWidget {
  const MqttTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tiqs MQTT Test')),
      body: BlocBuilder<MqttBloc, MqttState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is MqttMessageState) ...[
                  Text(
                    '📩 Message from Broker:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  SelectableText(state.message),
                ] else if (state is MqttConnected) ...[
                  const Text('✅ Connected to broker'),
                ] else if (state is MqttConnecting) ...[
                  const CircularProgressIndicator(),
                ] else ...[
                  const Text('🚫 Not connected yet'),
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    context.read<MqttBloc>().add(MqttConnectRequested());
                  },
                  child: const Text('🔌 Connect'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<MqttBloc>().add(
                          MqttMessageSent(
                              'flutter/response', 'Hello from Flutter'),
                        );
                  },
                  child: const Text('📤 Send Test Message'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
