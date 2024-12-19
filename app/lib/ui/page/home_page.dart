import 'package:app/ui/widgets/ausente_widget.dart';
import 'package:app/ui/widgets/custom_app_bar.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:app/ui/widgets/room_info.dart';
import 'package:app/ui/widgets/sensor_box.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentScreen = 'Home';

  void onSelectScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: AppDrawer(
        currentScreen: _currentScreen,
        onSelectScreen: onSelectScreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Ausente(),
            RoomInfo(roomName: 'Sala', icon: Icons.weekend),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SensorBox(
                            sensorName: 'LED',
                            icon: Icons.lightbulb,
                            iconColor: Colors.yellow,
                            value: '75%'),
                        SizedBox(height: 10),
                        SensorBox(
                            sensorName: 'Luz',
                            icon: Icons.wb_sunny,
                            iconColor: Color.fromARGB(255, 255, 136, 1),
                            value: '350 lux'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SensorBox(
                        sensorName: 'Presença',
                        icon: Icons.access_alarm,
                        iconColor: Colors.blue,
                        value: 'Ativo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
