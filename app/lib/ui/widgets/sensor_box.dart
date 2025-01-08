import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:app/services/sensorService.dart';
import 'package:flutter/material.dart';

class SensorBox extends StatelessWidget {
  late final String sensorName;
  late final IconData icon;
  late final Color iconColor;
  late final String comodo;
  String value;
  late String bValue;
  late String rValue;
  late String gValue;
  late RealtimeService realTimerProvider;

  SensorBox({
    super.key,
    required this.sensorName,
    required this.comodo,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.realTimerProvider,
  }) {
    Map<String, dynamic> dados = {value: value};
    Sensor sensor = Sensor(comodo: comodo, nome: sensorName, dados: dados);
    bValue = "";
    rValue = "";
    gValue = "";
    if (value != "{}" && value != "") {
      String removeChave = value.replaceAll("}", "");
      removeChave = removeChave.replaceAll("{", "");
      if (sensorName != "LED RGB") {
        print(sensorName);
        value = removeChave.split(" ").length > 1
            ? removeChave.split(" ")[1].replaceAll(",", "")
            : "Loading...";
      } else {
        List<String> parts = value.replaceAll(" ", "").split(',');

        // Iterar sobre as partes e atribuir os valores
        for (String part in parts) {
          if (part.startsWith("{b:")) {
            bValue = part.split(':')[1];
          } else if (part.startsWith("r:")) {
            rValue = part.split(':')[1];
          } else if (part.startsWith("g:")) {
            gValue = part.split(':')[1];
            gValue = gValue.replaceAll("}", "");
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.5, // 90% da largura da tela
      height: screenHeight * 0.2, // 20% da altura da tela
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(right: 0.6),
          child: Icon(icon, size: 30, color: iconColor),
        ),
        const SizedBox(width: 0.6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                sensorName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              if (sensorName == "Luminosidade" || sensorName == "Umidade")
                Text(
                  '$value % ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              if (sensorName == "Temperatura" ||
                  sensorName == "Ar-Condicionado")
                Text(
                  '$value °C',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              if (sensorName == "Presença")
                Text(
                  value == "1" ? " detectada" : "não detectado",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              if (sensorName == "Janela")
                Text(
                  value == "1" ? "aberta" : " fechada",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              if (sensorName == "LED RGB")
                Text(
                  'Red: $rValue Green: $gValue Blue: $bValue',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 10),
        if (sensorName == "Lâmpada" || sensorName == "Janela")
          CustomSwitch(realTimerProvider, comodo, sensorName, value),
      ]),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final String sensorName;
  CustomSwitch(RealtimeService realTimerProvider, String comodo,
      this.sensorName, String value);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _value = false;
  String _label = "Off";
  late String sensorName;
  @override
  void initState() {
    super.initState();
    sensorName = widget.sensorName;
  }

  void _toggleSwitch() {
    setState(() {
      _value = !_value;
      if (_value) {
        _label = "On";
      } else {
        _label = "Off";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: _value,
              onChanged: (bool newValue) {
                _toggleSwitch();
              },
              activeTrackColor:
                  widget.sensorName == "Lâmpada" ? Colors.yellow : Colors.blue,
              inactiveThumbColor: Colors.grey.shade300,
              inactiveTrackColor: Colors.grey.shade200,
            ),
          ],
        ),
      ],
    );
  }
}
