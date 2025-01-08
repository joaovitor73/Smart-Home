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
    //Sensor sensor = Sensor(comodo: comodo, nome: sensorName, dados: value);
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
    return Container(
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

        // const SizedBox(width: 0.6),
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
                  value == "1"
                      ? "Presença detectada"
                      : "Nenhuma presença detectada",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              if (sensorName == "Janela")
                Text(
                  value == "1" ? "Janela aberta" : "Janela fechada",
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
        if (sensorName == "Lâmpada" || sensorName == "Janela")
          Switch(
            value: value != "0" ? false : true, // Valor inicial do switch
            onChanged: (bool newValue) {
              value = newValue ? "Ligado" : "Desligado";
              // realTimerProvider
              //     .updateData( newValue ? "1" : "0");
            },
          ),
      ]),
    );
  }
}
