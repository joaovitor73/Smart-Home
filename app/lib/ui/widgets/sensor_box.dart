import 'package:flutter/material.dart';

class SensorBox extends StatelessWidget {
  late final String sensorName;
  late final IconData icon;
  late final Color iconColor;
  late final String value;

  SensorBox(
      {required this.sensorName,
      required this.icon,
      required this.iconColor,
      required value}) {
    String removeChave = value.replaceAll("}", "");
    this.value = removeChave.split(" ").length > 1
        ? removeChave.split(" ")[1].replaceAll(",", "")
        : "Loading...";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(right: 0.6),
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
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (sensorName == "LED" ||
            sensorName == "Servo" ||
            sensorName == "Motor")
          Switch(
            value: false, // Valor inicial do switch
            onChanged: (bool newValue) {
              value = newValue ? "Ligado" : "Desligado";
            },
          ),
      ]),
    );
  }
}
