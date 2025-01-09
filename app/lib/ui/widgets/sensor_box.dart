import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:app/services/sensorService.dart';
import 'package:app/ui/page/Color_page.dart';
import 'package:app/ui/page/Temperature_page.dart';
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
    //Sensor sensor = Sensor(comodo: comodo, nome: sensorName, dados: value);
    bValue = "";
    rValue = "";
    gValue = "";
    if (value != "{}" && value != "") {
      String removeChave = value.replaceAll("}", "");
      removeChave = removeChave.replaceAll("{", "");
      if (sensorName != "LED RGB") {
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize:
            MainAxisSize.min, // Faz com que a altura se ajuste ao conteúdo.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(right: 0.6),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sensorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (sensorName == "Umidade")
                    Text(
                      '$value % ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  if (sensorName == "Luminosidade")
                    Text(
                      '$value ',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  if (sensorName == "Temperatura")
                    Text(
                      '$value °C',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  if (sensorName == "Ar-Condicionado")
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de ajuste de LED RGB
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TemperaturePage(
                                  realtime_provider: realTimerProvider,
                                  comodo: comodo,
                                  sensor_name: sensorName)),
                        );
                      },
                      child: Text(
                        '$value °C',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  if (sensorName == "Presença")
                    Text(
                      value == '1' ? " detectada" : "não detectado",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  if (sensorName == "Janela")
                    Text(
                      value == '1' ? "aberta" : " fechada",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  if (sensorName == "LED RGB")
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de ajuste de LED RGB
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ColorAdjustmentScreen()),
                        );
                      },
                      child: Text(
                        'Red: $rValue Green: $gValue Blue: $bValue',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  if (sensorName == "Lâmpada")
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0), // Reduzi o espaço acima.
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSwitch(realTimerProvider, comodo, 'led', value),
                        ],
                      ),
                    ),
                  if (sensorName == "Janela")
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0), // Reduzi o espaço acima.
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomSwitch(
                              realTimerProvider, comodo, 'servo', value),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ]),
        ],
      )),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final RealtimeService realTimerProvider;
  final String comodo;
  final String sensorName;
  final String value;

  CustomSwitch(
      this.realTimerProvider, this.comodo, this.sensorName, this.value);

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

    // Inicializa o estado do switch com base no valor passado
    _value = widget.value == "1";
    _label = _value ? "On" : "Off";
  }

  void _toggleSwitch() {
    setState(() {
      _value = !_value;
      _label = _value ? "On" : "Off";

      // Cria um sensor com base nos parâmetros
      final sensor = Sensor(
        comodo: widget.comodo,
        nome: widget.sensorName,
        dados: {
          "valor": _value ? 1 : 0,
        },
      );
      // Chama o método updateData com o sensor
      widget.realTimerProvider.updateData(sensor: sensor);
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
