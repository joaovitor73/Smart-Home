import 'package:app/services/geolocator_service.dart';
import 'package:app/ui/widgets/AtuadoresItem.dart';
import 'package:app/ui/widgets/ConfigureScreen.dart';
import 'package:app/ui/widgets/DeviceItem.dart';
import 'package:app/ui/widgets/RoomCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instance.ref();
  String livingRoomLight = "Carregando...";
  String livingRoomTemperature = "Carregando...";
  String livingRoomHumidity = "Carregando...";
  String fetchedTemperature = "Carregando temperatura...";
  String fetchedHumidity = "Carregando umidade...";
  String fetchedLight = "Carregando luz...";

  final TextEditingController _lightController = TextEditingController();

  late GeoLocatorService geoLocatorService;

  @override
  void initState() {
    super.initState();
    geoLocatorService = Provider.of<GeoLocatorService>(context, listen: false);
    geoLocatorService.captureLocation();
    fetchSensorData("sala", "temperatura", (data) {
      setState(() {
        fetchedTemperature = data.toString();
      });
    });
    fetchSensorData("sala", "umidade", (data) {
      setState(() {
        fetchedHumidity = data.toString();
      });
    });
    fetchSensorData("sala", "luz", (data) {
      setState(() {
        fetchedLight = data.toString();
      });
    });
  }

  void fetchSensorData(
      String comodo, String sensor, Function(dynamic) onDataReceived) {
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .child(comodo)
        .child("sensores")
        .child(sensor)
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      onDataReceived(data);
    });
  }

  void updateSensorValue(String comodo, String sensor, String newValue) {
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .child(comodo)
        .child("sensores")
        .child(sensor)
        .set(newValue);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Minha Casa Inteligente',
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            onPressed: () {
              // Ação para configurar rotinas
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
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
                status: fetchedLight,
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
            atuadores: const [
              ActuatorControlWidget(
                  actuatorName: 'Lâmpada', icon: Icons.lightbulb)
            ],
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            roomName: 'Cozinha',
            icon: Icons.kitchen,
            devices: [
              DeviceItem(
                name: 'Umidade',
                status: fetchedHumidity,
                icon: Icons.water_drop,
              ),
              DeviceItem(
                name: 'Luz',
                status: fetchedLight,
                icon: Icons.light,
              ),
              const DeviceItem(
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
                      const ConfigurationScreen(roomName: 'Cozinha'),
                ),
              );
            },
            atuadores: const [
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
                  builder: (context) =>
                      const ConfigurationScreen(roomName: 'Quarto'),
                ),
              );
            },
            atuadores: const [
              ActuatorControlWidget(actuatorName: 'LED', icon: Icons.lightbulb),
              LedRgbControlWidget(),
              LcdControlWidget()
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
                      const ConfigurationScreen(roomName: 'Banheiro'),
                ),
              );
            },
            atuadores: const [
              ActuatorControlWidget(
                  actuatorName: 'Lâmpada', icon: Icons.lightbulb)
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
        ],
      ),
    );
  }
}
