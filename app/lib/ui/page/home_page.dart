import 'package:app/services/realtime_service.dart';
import 'package:app/services/sensorService.dart';
import 'package:app/ui/widgets/ausente_widget.dart';
import 'package:app/ui/widgets/custom_app_bar.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:app/ui/widgets/room_info.dart';
import 'package:app/ui/widgets/sensor_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sensorDataProvider =
          Provider.of<SensorDataProvider>(context, listen: false);

      final sensors = [
        {"comodo": "sala", "sensor": "luz"},
        {"comodo": "sala", "sensor": "led"},
        {"comodo": "sala", "sensor": "presenca"},
      ];

      for (var sensor in sensors) {
        sensorDataProvider.fetchSensorData(
            sensor['comodo']!, sensor['sensor']!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sensorDataProvider = Provider.of<SensorDataProvider>(context);
    final realTimerProvider = Provider.of<RealtimeService>(context);

    realTimerProvider.modoCabare();
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
                          value: sensorDataProvider.fetchedData['sala/led']
                                  ?.toString() ??
                              "Loading...",
                        ),
                        SizedBox(height: 10),
                        SensorBox(
                          sensorName: 'Luz',
                          icon: Icons.wb_sunny,
                          iconColor: Color.fromARGB(255, 255, 136, 1),
                          value: sensorDataProvider.fetchedData['sala/luz']
                                  ?.toString() ??
                              "Loading...",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SensorBox(
                      sensorName: 'Presença',
                      icon: Icons.access_alarm,
                      iconColor: Colors.blue,
                      value: sensorDataProvider.fetchedData['sala/presenca']
                              ?.toString() ??
                          "Loading...",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            RoomInfo(roomName: 'Quarto', icon: Icons.bed),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: realTimerProvider.modoCabare,
                icon: Icon(Icons.flash_on, color: Colors.white),
                label: Text("Ativar Modo Cabaré"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
