import 'package:app/ui/widgets/ConfigureScreen.dart';
import 'package:app/ui/widgets/DeviceItem.dart';
import 'package:app/ui/widgets/RoomCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instance.ref();
  String livingRoomLight = "Carregando...";
  String livingRoomTemperature = "Carregando...";
  String livingRoomHumidity = "Carregando...";
  final TextEditingController _lightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenToRealtimeChanges();
  }

  void listenToRealtimeChanges() {
    databaseRef
        .child("smart_home/json/comodos/sala/sensores/luz/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        livingRoomLight = data != null ? data.toString() : "N/A";
      });
    });

    databaseRef
        .child("smart_home/json/comodos/sala/sensores/temperatura")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        livingRoomTemperature = data.toString();
      });
    });

    databaseRef
        .child("smart_home/json/comodos/sala/sensores/umidade")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        livingRoomHumidity = data.toString();
      });
    });
  }

  Future<void> updateLightValue(String value) async {
    try {
      await databaseRef
          .child("smart_home/json/comodos/sala/sensores/luz")
          .update({"valor": value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Valor atualizado com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar o valor: $e")),
      );
    }
  }

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
        children: [
          RoomCard(
            roomName: 'Sala de Estar',
            temperature: livingRoomTemperature,
            humidity: livingRoomHumidity,
            devices: [
              DeviceItem(
                name: 'Luz',
                status: livingRoomLight,
                icon: Icons.lightbulb,
              ),
              DeviceItem(
                name: 'Temperatura',
                status: livingRoomTemperature,
                icon: Icons.thermostat,
              ),
              DeviceItem(
                name: 'Umidade',
                status: livingRoomHumidity,
                icon: Icons.water_drop,
              ),
            ],
            onConfigure: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfigurationScreen(roomName: 'Sala de Estar'),
                ),
              );
            },
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            roomName: 'Cozinha',
            temperature: 'N/A',
            humidity: 'N/A',
            devices: [
              DeviceItem(
                name: 'Shutter',
                status: 'Aberto 100%',
                icon: Icons.window,
              ),
              DeviceItem(
                name: 'Spotlights',
                status: 'Desligado',
                icon: Icons.light,
              ),
              DeviceItem(
                name: 'Worktop',
                status: 'Desligado',
                icon: Icons.kitchen,
              ),
              DeviceItem(
                name: 'Fridge',
                status: 'Fechado',
                icon: Icons.kitchen,
              ),
              DeviceItem(
                name: 'Nest Audio',
                status: 'Ligado',
                icon: Icons.speaker,
              ),
            ],
            onConfigure: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfigurationScreen(roomName: 'Cozinha'),
                ),
              );
            },
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            roomName: 'Energia',
            temperature: 'N/A',
            humidity: 'N/A',
            devices: const [
              DeviceItem(
                name: 'EV',
                status: 'Desconectado',
                icon: Icons.electric_car,
              ),
              DeviceItem(
                name: 'Last charge',
                status: '16,3 kWh',
                icon: Icons.battery_charging_full,
              ),
              DeviceItem(
                name: 'Home power',
                status: 'N/A',
                icon: Icons.electrical_services,
              ),
              DeviceItem(
                name: 'Voltage',
                status: 'N/A',
                icon: Icons.flash_on,
              ),
            ],
            onConfigure: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfigurationScreen(roomName: 'Energia'),
                ),
              );
            },
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _lightController,
            decoration: InputDecoration(
              labelText: "Novo valor para Luz",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              final newValue = _lightController.text;
              if (newValue.isNotEmpty) {
                updateLightValue(newValue);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Por favor, insira um valor válido")),
                );
              }
            },
            child: Text("Atualizar Luz"),
          ),
        ],
      ),
    );
  }
}
