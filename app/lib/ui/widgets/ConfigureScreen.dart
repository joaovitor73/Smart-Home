import 'package:flutter/material.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen(
      {super.key, required this.roomName, required this.atuadores});
  final String roomName;
  final List<dynamic> atuadores;
  @override
  ConfigurationScreenState createState() => ConfigurationScreenState();
}

class ConfigurationScreenState extends State<ConfigurationScreen> {
  bool isPresentRoutineLightOn = false;
  bool isPresentRoutineCurtainOpen = false;
  String presentRoutineAirConditionerTemp = "22";

  bool isAbsentRoutineLightOff = false;
  bool isAbsentRoutineCurtainClosed = false;
  bool isAbsentRoutineAirConditionerOff = false;
  Rea
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajuste de Rotinas  ${widget.roomName}"),
        backgroundColor: Color.fromARGB(255, 12, 182, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Rotina 1: Quando presente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text("Luz: Ligar"),
              value: isPresentRoutineLightOn,
              onChanged: (bool value) {
                setState(() {
                  isPresentRoutineLightOn = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text("Cortina: Abrir"),
              value: isPresentRoutineCurtainOpen,
              onChanged: (bool value) {
                setState(() {
                  isPresentRoutineCurtainOpen = value;
                });
              },
            ),
            ListTile(
              title: const Text("Ar-condicionado:"),
              subtitle: TextField(
                decoration: const InputDecoration(
                  labelText: "Temperatura (°C)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    presentRoutineAirConditionerTemp = value;
                  });
                },
                controller: TextEditingController(
                    text: presentRoutineAirConditionerTemp),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Rotina 2: Quando ausente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text("Luz: Desligar"),
              value: isAbsentRoutineLightOff,
              onChanged: (bool value) {
                setState(() {
                  isAbsentRoutineLightOff = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text("Cortina: Fechar"),
              value: isAbsentRoutineCurtainClosed,
              onChanged: (bool value) {
                setState(() {
                  isAbsentRoutineCurtainClosed = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text("Ar-condicionado: Desligar"),
              value: isAbsentRoutineAirConditionerOff,
              onChanged: (bool value) {
                setState(() {
                  isAbsentRoutineAirConditionerOff = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
