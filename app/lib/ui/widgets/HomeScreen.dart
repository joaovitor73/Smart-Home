import 'package:app/ui/widgets/RoomCard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Casa Inteligente'),
        actions: [
          IconButton(
            onPressed: () {
              // Ação para configurar rotinas
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Card da Sala de Estar
          RoomCard(
            roomName: 'Sala de Estar',
            temperature: '22,8 °C',
            humidity: '57%',
            devices: [
              'Floor lamp - 70%',
              'Spotlights - 49%',
              'Bar lamp - Ligado',
              'Blinds - Aberto 100%',
              'Nest Mini - Reproduzindo',
            ],
          ),
          SizedBox(height: 16.0),

          // Card da Cozinha
          RoomCard(
            roomName: 'Cozinha',
            temperature: 'N/A',
            humidity: 'N/A',
            devices: [
              'Shutter - Aberto 100%',
              'Spotlights - Desligado',
              'Worktop - Desligado',
              'Fridge - Fechado',
              'Nest Audio - Ligado',
            ],
          ),
          SizedBox(height: 16.0),

          // Card da Energia
          RoomCard(
            roomName: 'Energia',
            temperature: 'N/A',
            humidity: 'N/A',
            devices: [
              'EV - Desconectado',
              'Last charge - 16,3 kWh',
              'Home power - N/A',
              'Voltage - N/A',
            ],
          ),
        ],
      ),
    );
  }
}
