import 'package:app/ui/widgets/DeviceItem.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String temperature;
  final String humidity;
  final List<DeviceItem> devices;
  final VoidCallback onConfigure;

  const RoomCard({
    Key? key,
    required this.roomName,
    required this.temperature,
    required this.humidity,
    required this.devices,
    required this.onConfigure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50], // Cor de fundo do card
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordas arredondadas
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roomName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900], // Cor do texto
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Temperatura: $temperature',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[700], // Cor do texto
              ),
            ),
            Text(
              'Umidade: $humidity',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[700], // Cor do texto
              ),
            ),
            const SizedBox(height: 8.0),
            ...devices
                .map((device) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: device,
                    ))
                .toList(),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onConfigure,
                child: const Text("Configurar"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey, // Cor do texto do botão
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
