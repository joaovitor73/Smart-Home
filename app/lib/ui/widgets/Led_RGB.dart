import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:app/services/shared_service.dart';
import 'package:flutter/material.dart';

class LedRgbControlWidget extends StatefulWidget {
  final String rotina;
  const LedRgbControlWidget({super.key, required this.rotina});

  @override
  State<LedRgbControlWidget> createState() => _LedRgbControlWidgetState();
}

class _LedRgbControlWidgetState extends State<LedRgbControlWidget> {
  bool isRgbOn = false; // Estado do LED RGB (ligado/desligado)
  double red = 0;
  double green = 0;
  double blue = 0;
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
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isRgbOn
                      ? Colors.blue.shade50
                      : Colors.grey.shade300, // Cor ao ligar/desligar
                  child: Icon(
                    Icons.lightbulb,
                    color: isRgbOn ? Colors.blueAccent : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Luz RGB",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isRgbOn ? Colors.blueAccent : Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isRgbOn,
                  onChanged: (value) {
                    setState(() {
                      isRgbOn = value;
                      if (!isRgbOn) {
                        red = green = blue = 0; // Zera os valores ao desligar
                        realtimeService.updateData(
                            sensor: Sensor(
                                comodo: comodo,
                                nome: "led_rgb",
                                dados: {"r": red, "g": green, "b": blue}));
                        widget.rotina != ""
                            ? SharedService.salvarSensor(
                                widget.rotina,
                                Sensor(
                                    comodo: comodo,
                                    nome: "led_rgb",
                                    dados: {"r": red, "g": green, "b": blue}))
                            : null;
                      }
                    });
                  },
                  activeColor: Colors.blueAccent,
                  inactiveThumbColor: Colors.grey,
                ),
              ],
            ),
            if (isRgbOn) ...[
              const SizedBox(height: 16),
              Text(
                "RGB: R: ${red.toInt()} G: ${green.toInt()} B: ${blue.toInt()}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.redAccent,
                  inactiveTrackColor: Colors.red.shade50,
                  thumbColor: Colors.red,
                  trackHeight: 8.0,
                ),
                child: Slider(
                  value: red,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "R:  ${red.toInt()}",
                  onChanged: (value) {
                    setState(() {
                      red = value;
                      realtimeService.updateData(
                          sensor: Sensor(
                              comodo: comodo,
                              nome: "led_rgb",
                              dados: {"r": red, "g": green, "b": blue}));
                      widget.rotina != ""
                          ? SharedService.salvarSensor(
                              widget.rotina,
                              Sensor(
                                  comodo: comodo,
                                  nome: "led_rgb",
                                  dados: {"r": red, "g": green, "b": blue}))
                          : null;
                    });
                  },
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.greenAccent,
                  inactiveTrackColor: Colors.green.shade50,
                  thumbColor: Colors.green,
                  trackHeight: 8.0,
                ),
                child: Slider(
                  value: green,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "G:  ${green.toInt()}",
                  onChanged: (value) {
                    setState(() {
                      green = value;
                      realtimeService.updateData(
                          sensor: Sensor(
                              comodo: comodo,
                              nome: "led_rgb",
                              dados: {"r": red, "g": green, "b": blue}));
                      widget.rotina != ""
                          ? SharedService.salvarSensor(
                              widget.rotina,
                              Sensor(
                                  comodo: comodo,
                                  nome: "led_rgb",
                                  dados: {"r": red, "g": green, "b": blue}))
                          : null;
                    });
                  },
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.blue.shade50,
                  thumbColor: Colors.blue,
                  trackHeight: 8.0,
                ),
                child: Slider(
                  value: blue,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "B:  ${blue.toInt()}",
                  onChanged: (value) {
                    setState(() {
                      blue = value;
                      realtimeService.updateData(
                          sensor: Sensor(
                              comodo: comodo,
                              nome: "led_rgb",
                              dados: {"r": red, "g": green, "b": blue}));
                      widget.rotina != ""
                          ? SharedService.salvarSensor(
                              widget.rotina,
                              Sensor(
                                  comodo: comodo,
                                  nome: "led_rgb",
                                  dados: {"r": red, "g": green, "b": blue}))
                          : null;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
