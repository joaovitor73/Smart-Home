import 'package:app/services/geolocator_service.dart';
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
  const HomePage({super.key});

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
        {"comodo": "banheiro", "sensor": "luz"},
        {"comodo": "banheiro", "sensor": "led"},
        {"comodo": "cozinha", "sensor": "umidade"},
        {"comodo": "cozinha", "sensor": "luz"},
        {"comodo": "cozinha", "sensor": "temperatura"},
        {"comodo": "cozinha", "sensor": "led"},
        {"comodo": "quarto", "sensor": "umidade"},
        {"comodo": "quarto", "sensor": "luz"},
        {"comodo": "quarto", "sensor": "temperatura"},
        {"comodo": "quarto", "sensor": "lcd"},
        {"comodo": "quarto", "sensor": "motor"},
        {"comodo": "quarto", "sensor": "led_rgb"},
        {"comodo": "quarto", "sensor": "servo"},
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
    final geolocatorProvider =
        Provider.of<GeoLocatorService>(context, listen: true);

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: AppDrawer(
        currentScreen: _currentScreen,
        onSelectScreen: onSelectScreen,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Ausente(isAusente: geolocatorProvider.isPresent),
            RoomInfo(roomName: 'Sala', icon: Icons.weekend),
            _buildRoomSensors(
                sensorDataProvider,
                'sala',
                [
                  {
                    'sensorName': 'led',
                    'icon': Icons.lightbulb,
                    'iconColor': Colors.yellow,
                  },
                  {
                    'sensorName': 'luz',
                    'icon': Icons.wb_sunny,
                    'iconColor': const Color.fromARGB(255, 255, 136, 1)
                  },
                  {
                    'sensorName': 'presenca',
                    'icon': Icons.access_alarm,
                    'iconColor': Colors.blue
                  },
                  {
                    'sensorName': 'Servo',
                    'icon': Icons.window,
                    'iconColor': Colors.blue
                  }
                ],
                realTimerProvider),
            RoomInfo(roomName: 'Banheiro', icon: Icons.bathroom),
            _buildRoomSensors(
                sensorDataProvider,
                'banheiro',
                [
                  {
                    'sensorName': 'luz',
                    'icon': Icons.wb_sunny,
                    'iconColor': const Color.fromARGB(255, 255, 136, 1),
                  },
                  {
                    'sensorName': 'led',
                    'icon': Icons.lightbulb,
                    'iconColor': Colors.yellow
                  },
                ],
                realTimerProvider),
            RoomInfo(roomName: 'Cozinha', icon: Icons.kitchen),
            _buildRoomSensors(
                sensorDataProvider,
                'cozinha',
                [
                  {
                    'sensorName': 'Umidade',
                    'icon': Icons.water_drop,
                    'iconColor': Colors.blue
                  },
                  {
                    'sensorName': 'luz',
                    'icon': Icons.wb_sunny,
                    'iconColor': const Color.fromARGB(255, 255, 136, 1)
                  },
                  {
                    'sensorName': 'Temperatura',
                    'icon': Icons.thermostat,
                    'iconColor': Colors.red
                  },
                  {
                    'sensorName': 'led',
                    'icon': Icons.lightbulb,
                    'iconColor': Colors.yellow
                  },
                ],
                realTimerProvider),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 0),
              child: GestureDetector(
                onTap: realTimerProvider
                    .modoCabareLigar, // Ativa o modo quando clicado
                onLongPress: realTimerProvider
                    .modoCabareDesligar, // Desativa o modo ao pressionar
                child: ElevatedButton.icon(
                  onPressed:
                      null, // Desative o onPressed do botão, pois usamos GestureDetector
                  icon: const Icon(Icons.favorite, color: Colors.blue),
                  label: const Text(
                    "Modo Love",
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ),
            RoomInfo(roomName: 'Quarto', icon: Icons.bed),
            _buildRoomSensors(
                sensorDataProvider,
                'quarto',
                [
                  {
                    'sensorName': 'Umidade',
                    'icon': Icons.water_drop,
                    'iconColor': Colors.blue
                  },
                  {
                    'sensorName': 'luz',
                    'icon': Icons.wb_sunny,
                    'iconColor': const Color.fromARGB(255, 255, 136, 1)
                  },
                  {
                    'sensorName': 'Temperatura',
                    'icon': Icons.thermostat,
                    'iconColor': Colors.red
                  },
                  {
                    'sensorName': 'lcd',
                    'icon': Icons.snowing,
                    'iconColor': Colors.blue
                  },
                  {
                    'sensorName': 'Motor',
                    'icon': Icons.build,
                    'iconColor': Colors.grey
                  },
                  {
                    'sensorName': 'led_rgb',
                    'icon': Icons.lightbulb_outline,
                    'iconColor': Colors.purple
                  },
                ],
                realTimerProvider),
          ],
        ),
      ),
    );
  }
}

Widget _buildRoomSensors(SensorDataProvider provider, String roomName,
    List<Map<String, dynamic>> sensors, RealtimeService realTimerProvider) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: sensors.map((sensor) {
        final sensorKey = '$roomName/${sensor['sensorName'].toLowerCase()}';
        String sensorName = sensor['sensorName'];
        final sensorValue =
            provider.fetchedData[sensorKey]?.toString() ?? "...Loading";
        if (sensor['sensorName'] == "led") {
          sensorName = "Lâmpada";
        } else if (sensor['sensorName'] == "luz") {
          sensorName = "Luminosidade";
        } else if (sensor['sensorName'] == "presenca") {
          sensorName = "Presença";
        } else if (sensor['sensorName'] == "lcd") {
          sensorName = "Ar-Condicionado";
        } else if (sensor['sensorName'] == "led_rgb") {
          sensorName = "LED RGB";
        } else if (sensor['sensorName'] == "Servo") {
          sensorName = "Janela";
        }
        if (sensor['sensorName'] != "Motor") {
          return SensorBox(
            sensorName: sensorName,
            comodo: roomName,
            icon: sensor['icon'],
            iconColor: sensor['iconColor'],
            value: sensorValue,
            realTimerProvider: realTimerProvider,
          );
        } else {
          return const SizedBox(
            width: 0,
          );
        }
      }).toList(),
    ),
  );
}
