import 'package:app/services/realtime_service.dart';
import 'package:app/domain/Sensor.dart';
import 'package:app/services/sensorService.dart';
import 'package:app/ui/widgets/custom_app_bar.dart';
import 'package:app/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemperaturePage extends StatefulWidget {
  final RealtimeService realtime_provider;
  final String comodo;
  final String sensor_name;
  String isOn = 'false';

  TemperaturePage({
    required this.realtime_provider,
    required this.comodo,
    required this.sensor_name,
  });
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  int setTemperature = 20; // Valor padrão
  String _currentScreen = 'Temperatura';

  @override
  void initState() {
    super.initState();
    final sensorDataProvider =
        Provider.of<SensorDataProvider>(context, listen: false);
    final sensorKey = 'quarto/lcd';

    // Obtenha o valor inicial do sensor
    final sensorValue =
        sensorDataProvider.fetchedData[sensorKey]?.toString() ?? "...Loading";

    try {
      final match = RegExp(r'\{valor:\s*(\d+)\}').firstMatch(sensorValue);
      if (match != null) {
        setTemperature =
            int.parse(match.group(1)!); // Inicialize com o valor do sensor
      }
    } catch (e) {
      print('Erro ao processar sensorValue no initState: $e');
    }
  }

  void onSelectScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sensorDataProvider = Provider.of<SensorDataProvider>(context);
    final realTimerProvider = Provider.of<RealtimeService>(context);
    final sensorKey = 'quarto/lcd';
    String sensorName = 'lcd';

    // Obtenha o valor do sensor
    final sensorValue =
        sensorDataProvider.fetchedData[sensorKey]?.toString() ?? "...Loading";

    // Extraia o valor numérico do sensorValue para exibição
    String displayedValue = "...";
    try {
      final match = RegExp(r'\{valor:\s*(\d+)\}').firstMatch(sensorValue);
      if (match != null) {
        displayedValue = match.group(1)!;
      }
    } catch (e) {
      print('Erro ao processar sensorValue: $e');
    }

    final Sensor sensor = Sensor(nome: 'lcd', comodo: widget.comodo, dados: {
      "valor": setTemperature,
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      drawer: AppDrawer(
        currentScreen: 'TemperaturePage',
        onSelectScreen: onSelectScreen,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.thermostat_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Temperatura Atual',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${displayedValue} °C',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        setTemperature = (setTemperature - 1).clamp(16, 30);
                        widget.realtime_provider.updateData(sensor: sensor);
                      });
                    },
                    child: const Icon(Icons.remove, size: 30),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        setTemperature = (setTemperature + 1).clamp(16, 30);
                        widget.realtime_provider.updateData(sensor: sensor);
                      });
                    },
                    child: const Icon(Icons.add, size: 30),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Slider(
                value: setTemperature.toDouble(),
                min: 16,
                max: 30,
                divisions: 14,
                activeColor: Colors.white,
                inactiveColor: Colors.white54,
                onChanged: (double value) {
                  setState(() {
                    setTemperature = value.toInt();
                    widget.realtime_provider.updateData(sensor: sensor);
                  });
                },
              ),
              Text(
                'Ajustar para: $setTemperature°C',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
