import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:app/services/shared_service.dart';
import 'package:flutter/material.dart';

class LcdControlWidget extends StatefulWidget {
  final String rotina;
  const LcdControlWidget({super.key, required this.rotina});

  @override
  State<LcdControlWidget> createState() => _LcdControlWidgetState();
}

class _LcdControlWidgetState extends State<LcdControlWidget> {
  bool isLcdOn = false; // Estado do LCD (ligado/desligado)
  int temperature = 24; // Temperatura padrão
  String comodo = "quarto";
  RealtimeService realtimeService = RealtimeService();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com botão de ligar/desligar
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      isLcdOn ? Colors.lightBlue[100] : Colors.grey[300],
                  child: Icon(
                    Icons.ac_unit, // Ícone de ar-condicionado
                    color: isLcdOn ? Colors.blue : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Ar-Condicionado",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isLcdOn ? Colors.blue : Colors.grey[700],
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isLcdOn,
                  onChanged: (value) {
                    setState(() {
                      isLcdOn = value;
                      realtimeService.updateData(
                          sensor: Sensor(comodo: comodo, nome: "lcd", dados: {
                        "ligado": isLcdOn,
                        "valor": temperature
                      }));
                      widget.rotina != ""
                          ? SharedService.salvarSensor(
                              widget.rotina,
                              Sensor(comodo: comodo, nome: "lcd", dados: {
                                "ligado": isLcdOn,
                                "valor": temperature
                              }))
                          : null;
                    });
                  },
                  activeColor: Colors.blue,
                  inactiveThumbColor: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Corpo das funcionalidades
            if (isLcdOn) ...[
              // Ajuste de temperatura
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Temperatura:",
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (temperature > 16) temperature--;
                            realtimeService.updateData(
                                sensor: Sensor(
                                    comodo: comodo,
                                    nome: "lcd",
                                    dados: {
                                  "ligado": isLcdOn,
                                  "valor": temperature
                                }));
                            widget.rotina != ""
                                ? SharedService.salvarSensor(
                                    widget.rotina,
                                    Sensor(comodo: comodo, nome: "lcd", dados: {
                                      "ligado": isLcdOn,
                                      "valor": temperature
                                    }))
                                : null;
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        "$temperature°C",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (temperature < 30) temperature++;
                            realtimeService.updateData(
                                sensor: Sensor(
                                    comodo: comodo,
                                    nome: "lcd",
                                    dados: {
                                  "ligado": isLcdOn,
                                  "valor": temperature
                                }));
                            widget.rotina != ""
                                ? SharedService.salvarSensor(
                                    widget.rotina,
                                    Sensor(comodo: comodo, nome: "lcd", dados: {
                                      "ligado": isLcdOn,
                                      "valor": temperature
                                    }))
                                : null;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Exibição do status no "LCD"
            ],
            // Quando desligado
            const Center(),
          ],
        ),
      ),
    );
  }
}
