import 'dart:convert';

import 'package:app/domain/Sensor.dart';
import 'package:app/services/shared_service.dart';
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
  List<Sensor> sensors = [];
  String livingRoomLight = "Carregando...";
  String banheirotemp = "Carregando...";
  String banheiroLuz = "Carregando...";
  String cozinhaHumidade = "Carregando...";
  String cozinhaTemp = "Carregando...";
  String salaPresenca = "Carregando...";
  String cozinhaLuz = "Carregando...";
  String quartoUmidade = "Carregando...";
  String quartoTemp = "Carregando...";
  String quartoLuz = "Carregando...";
  final TextEditingController _lightController = TextEditingController();
  final TextEditingController _comodoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dadosController = TextEditingController();

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
        .child("smart_home/json/comodos/cozinha/sensores/temperatura/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        cozinhaTemp = data != null ? data.toString() : "N/A";
      });
    });
    databaseRef
        .child("smart_home/json/comodos/cozinha/sensores/umidade/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        cozinhaHumidade = data != null ? data.toString() : "N/A";
      });
    });
    databaseRef
        .child("smart_home/json/comodos/cozinha/sensores/luz/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        cozinhaLuz = data != null ? data.toString() : "N/A";
      });
    });

    databaseRef
        .child("smart_home/json/comodos/sala/sensores/presença/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        cozinhaHumidade = data != null ? data.toString() : "N/A";
      });
    });
    databaseRef
        .child("smart_home/json/comodos/banheiro/sensores/luz/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        banheiroLuz = data != null ? data.toString() : "N/A";
      });
    });
    databaseRef
        .child("smart_home/json/comodos/quarto/sensores/umidade/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        quartoUmidade = data != null ? data.toString() : "N/A";
      });
    });
    databaseRef
        .child("smart_home/json/comodos/quarto/sensores/temperatura/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        quartoTemp = data != null ? data.toString() : "N/A";
      });
    });
    databaseRef
        .child("smart_home/json/comodos/quarto/sensores/luz/valor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        quartoLuz = data != null ? data.toString() : "N/A";
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
                status: livingRoomLight,
                icon: Icons.light,
              ),
              DeviceItem(
                name: 'Presença',
                status: salaPresenca,
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
                actuatorName: 'luz',
                icon: Icons.lightbulb,
                comodo: "sala",
              ),
              ActuatorControlWidget(
                actuatorName: 'led',
                icon: Icons.lightbulb,
                comodo: "sala",
              )
            ],
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            roomName: 'Cozinha',
            icon: Icons.kitchen,
            devices: [
              DeviceItem(
                name: 'Umidade',
                status: cozinhaHumidade,
                icon: Icons.water_drop,
              ),
              DeviceItem(
                name: 'Luz',
                status: cozinhaLuz,
                icon: Icons.light,
              ),
              DeviceItem(
                name: 'Temperatura',
                status: cozinhaTemp,
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
            atuadores: [
              ActuatorControlWidget(
                  actuatorName: 'luz', icon: Icons.lightbulb, comodo: "cozinha")
            ],
          ),
          const SizedBox(height: 16.0),
          RoomCard(
            icon: Icons.bedroom_parent,
            roomName: 'Quarto',
            devices: [
              DeviceItem(
                name: 'Umidade',
                status: quartoUmidade,
                icon: Icons.water_drop,
              ),
              DeviceItem(
                name: 'Temperatura',
                status: quartoTemp,
                icon: Icons.thermostat,
              ),
              DeviceItem(
                name: 'Luz',
                status: quartoLuz,
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
              ActuatorControlWidget(
                actuatorName: 'luz',
                icon: Icons.lightbulb,
                comodo: "quarto",
              ),
              LedRgbControlWidget()
            ],
          ),
          RoomCard(
            icon: Icons.bathtub,
            roomName: 'Banheiro',
            devices: [
              DeviceItem(
                name: 'Luz',
                status: banheiroLuz,
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
              ActuatorControlWidget(
                actuatorName: 'Lâmpada',
                icon: Icons.lightbulb,
                comodo: "banheiro",
              )
            ],
          ),
        ],
      ),
    );
  }
}
