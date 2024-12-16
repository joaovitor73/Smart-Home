import 'package:app/ui/widgets/DeviceItem.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final IconData icon;
  final String roomName;
  final List<DeviceItem> devices;
  final List<dynamic> atuadores;
  final VoidCallback onTap;

  const RoomCard({
    Key? key,
    required this.icon,
    required this.atuadores,
    required this.roomName,
    required this.devices,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Ação ao tocar no card
      borderRadius: BorderRadius.circular(15.0), // Feedback de toque
      child: Card(
        color: Colors.blueGrey[50], // Cor de fundo do card
        elevation: 4,

        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 32), // Ícone do card
                  const SizedBox(width: 8.0),
                  Text(
                    roomName,
                    style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, // Cor do texto
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Divider(color: Colors.blueGrey[300]), // Linha divisória
              const SizedBox(height: 8.0),
              ...devices
                  .map((device) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: device,
                      ))
                  .toList(),
              const SizedBox(height: 8.0),
              ...atuadores
                  .map((atuador) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: atuador,
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
