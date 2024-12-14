import 'package:app/ui/widgets/AtuadoresItem.dart';
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
            icon: Icons.home,
            roomName: 'Sala',
            devices: [
              DeviceItem(
                name: 'Luz',
                status: livingRoomLight,
                icon: Icons.light,
              ),
              DeviceItem(
                name: 'Presença',
                status: livingRoomTemperature,
                icon: Icons.priority_high_rounded,
              ),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ConfigurationScreen(roomName: 'Sala'),
                ),
              );
            },
            atuadores: [
              ActuatorControlWidget(actuatorName: 'LED', icon: Icons.lightbulb)
            ],
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            roomName: 'Cozinha',
            icon: Icons.kitchen,
            devices: [
              DeviceItem(
                name: 'Umidade',
                status: 'Aberto 100%',
                icon: Icons.water_drop,
              ),
              DeviceItem(
                name: 'Luz',
                status: 'Desligado',
                icon: Icons.light,
              ),
              DeviceItem(
                name: 'Temperatura',
                status: 'Fechado',
                icon: Icons.thermostat,
              ),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfigurationScreen(roomName: 'Cozinha'),
                ),
              );
            },
            atuadores: [
              ActuatorControlWidget(
                actuatorName: 'LED',
                icon: Icons.lightbulb,
              )
            ],
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            icon: Icons.bedroom_parent,
            roomName: 'Quarto',
            devices: const [
              DeviceItem(
                name: 'Umidade',
                status: 'Aberto 100%',
                icon: Icons.water_drop,
              ),
              DeviceItem(
                name: 'Temperatura',
                status: 'Fechado',
                icon: Icons.thermostat,
              ),
              DeviceItem(
                name: 'Luz',
                status: 'N/A',
                icon: Icons.light,
              ),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigurationScreen(roomName: 'Quarto'),
                ),
              );
            },
            atuadores: [
              ActuatorControlWidget(actuatorName: 'LED', icon: Icons.lightbulb)
            ],
          ),
          RoomCard(
            icon: Icons.bathtub,
            roomName: 'Banheiro',
            devices: const [
              DeviceItem(
                name: 'Luz',
                status: 'Aberto 100%',
                icon: Icons.light,
              ),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ConfigurationScreen(roomName: 'Banheiro'),
                ),
              );
            },
            atuadores: [
              ActuatorControlWidget(actuatorName: 'LED', icon: Icons.lightbulb)
            ],
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _lightController,
            decoration: const InputDecoration(
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
