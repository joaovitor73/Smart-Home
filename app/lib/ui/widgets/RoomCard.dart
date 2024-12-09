import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String temperature;
  final String humidity;
  final List<String> devices;

  const RoomCard({
    Key? key,
    required this.roomName,
    required this.temperature,
    required this.humidity,
    required this.devices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roomName,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text('Temperatura: $temperature'),
            Text('Umidade: $humidity'),
            const Divider(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: devices
                  .map((device) => Text(
                        '• $device',
                        style: const TextStyle(fontSize: 16.0),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
