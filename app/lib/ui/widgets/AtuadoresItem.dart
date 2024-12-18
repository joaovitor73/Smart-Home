import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ActuatorControlWidget extends StatefulWidget {
  final String actuatorName; // Nome do atuador (ex.: "Luz", "Motor")
  final IconData icon; // Ícone a ser exibido
  final String comodo;

  const ActuatorControlWidget({
    super.key,
    required this.actuatorName,
    required this.icon,
    required this.comodo,
  });

  @override
  State<ActuatorControlWidget> createState() => _ActuatorControlWidgetState();
}

class _ActuatorControlWidgetState extends State<ActuatorControlWidget> {
  bool isOn = false; // Estado do atuador (ligado/desligado)
  double power = 0;
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
                  backgroundColor: isOn ? Colors.yellow[100] : Colors.grey[300],
                  child: Icon(
                    widget.icon,
                    color: isOn ? Colors.orange : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.actuatorName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isOn ? Colors.orange : Colors.grey[700],
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isOn,
                  onChanged: (value) {
                    setState(() {
                      isOn = value;
                      if (!isOn) {
                        power = 0;
                        realtimeService.updateData(
                            sensor: Sensor(
                                comodo: widget.comodo.toString(),
                                nome: widget.actuatorName,
                                dados: {
                              "valor": power
                            })); // Zera a potência ao desligar
                      } else {
                        realtimeService.updateData(
                            sensor: Sensor(
                                comodo: widget.comodo.toString(),
                                nome: widget.actuatorName,
                                dados: {"valor": power}));
                      }
                    });
                  },
                  activeColor: Colors.orange,
                  inactiveThumbColor: Colors.grey,
                ),
              ],
            ),
            if (isOn) ...[
              const SizedBox(height: 16),
              Text(
                "Potência: ${power.toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor:
                      Colors.orangeAccent.shade100, // Cor da faixa ativa
                  inactiveTrackColor:
                      Colors.yellow.shade50, // Cor da faixa inativa
                  trackHeight: 12.0, // Altura da faixa
                  thumbColor: Colors.orangeAccent, // Cor do botão deslizante
                  thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10.0), // Tamanho do botão
                  overlayColor: Colors.orangeAccent
                      .withAlpha(50), // Efeito ao tocar no botão
                  overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20.0), // Tamanho da sobreposição
                ),
                child: Slider(
                  value: power,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: "${power.toStringAsFixed(0)}%", // Texto da porcentagem
                  onChanged: (value) {
                    setState(() {
                      power = value;
                      realtimeService.updateData(
                          sensor: Sensor(
                              comodo: widget.comodo.toString(),
                              nome: widget.actuatorName,
                              dados: {"valor": power}));
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

class LedRgbControlWidget extends StatefulWidget {
  const LedRgbControlWidget({super.key});

  @override
  State<LedRgbControlWidget> createState() => _LedRgbControlWidgetState();
}

class _LedRgbControlWidgetState extends State<LedRgbControlWidget> {
  bool isRgbOn = false; // Estado do LED RGB (ligado/desligado)
  double red = 0;
  double green = 0;
  double blue = 0;

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
                "RGB: R${red.toInt()} G${green.toInt()} B${blue.toInt()}",
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
                  label: "R: ${red.toInt()}",
                  onChanged: (value) {
                    setState(() {
                      red = value;
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
                  label: "G: ${green.toInt()}",
                  onChanged: (value) {
                    setState(() {
                      green = value;
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
                  label: "B: ${blue.toInt()}",
                  onChanged: (value) {
                    setState(() {
                      blue = value;
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

class LcdControlWidget extends StatefulWidget {
  const LcdControlWidget({super.key});

  @override
  State<LcdControlWidget> createState() => _LcdControlWidgetState();
}

class _LcdControlWidgetState extends State<LcdControlWidget> {
  bool isLcdOn = false; // Estado do LCD (ligado/desligado)
  int temperature = 24; // Temperatura padrão

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
              const Text(
                "Status do LCD:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Temperatura: $temperature°C",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: "Courier",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              // Quando desligado
              const Center(),
          ],
        ),
      ),
    );
  }
}
