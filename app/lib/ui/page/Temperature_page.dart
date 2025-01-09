import 'package:app/services/realtime_service.dart';
import 'package:app/domain/Sensor.dart';
import 'package:app/ui/widgets/sensor_box.dart';
import 'package:flutter/material.dart';

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
  int setTemperature = 20;

  @override
  Widget build(BuildContext context) {
    final Sensor sensor = Sensor(nome: 'lcd', comodo: widget.comodo, dados: {
      "valor": setTemperature,
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Controle de Temperatura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomSwitch(widget.realtime_provider, widget.comodo,
            //     widget.sensor_name, widget.isOn),
            SizedBox(height: 20),
            //if (widget.isOn == "true" || widget.isOn == "1")
            const Text(
              'Temperatura atual',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            Text(
              '${setTemperature.toStringAsFixed(1)} °C',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Ajustar temperatura',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      setTemperature = (setTemperature - 1).clamp(16, 30);
                      widget.realtime_provider.updateData(sensor: sensor);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      setTemperature = (setTemperature + 1).clamp(16, 30);
                      widget.realtime_provider.updateData(sensor: sensor);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
