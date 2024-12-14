import 'package:flutter/material.dart';

class ActuatorControlWidget extends StatefulWidget {
  final String actuatorName; // Nome do atuador (ex.: "Luz", "Motor")
  final IconData icon; // Ícone a ser exibido

  const ActuatorControlWidget({
    Key? key,
    required this.actuatorName,
    required this.icon,
  }) : super(key: key);

  @override
  State<ActuatorControlWidget> createState() => _ActuatorControlWidgetState();
}

class _ActuatorControlWidgetState extends State<ActuatorControlWidget> {
  bool isOn = false; // Estado do atuador (ligado/desligado)
  double power = 0; // Potência inicial do atuador (0-100%)

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
                        power = 0; // Zera a potência ao desligar
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
              Slider(
                value: power,
                min: 0,
                max: 100,
                divisions: 20,
                label: "${power.toStringAsFixed(0)}%",
                onChanged: (value) {
                  setState(() {
                    power = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LedRgbControlWidget extends StatefulWidget {
  const LedRgbControlWidget({Key? key}) : super(key: key);

  @override
  _LedRgbControlWidgetState createState() => _LedRgbControlWidgetState();
}

class _LedRgbControlWidgetState extends State<LedRgbControlWidget> {
  bool isRgbOn = false;
  double red = 0;
  double green = 0;
  double blue = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Controle do LED RGB",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("RGB"),
                Switch(
                  value: isRgbOn,
                  onChanged: (value) {
                    setState(() {
                      isRgbOn = value;
                      if (!isRgbOn) {
                        red = green = blue = 0;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Slider(
                  value: red,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "R: ${red.toInt()}",
                  activeColor: Colors.red,
                  onChanged: isRgbOn
                      ? (value) {
                          setState(() {
                            red = value;
                          });
                        }
                      : null,
                ),
                Slider(
                  value: green,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "G: ${green.toInt()}",
                  activeColor: Colors.green,
                  onChanged: isRgbOn
                      ? (value) {
                          setState(() {
                            green = value;
                          });
                        }
                      : null,
                ),
                Slider(
                  value: blue,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: "B: ${blue.toInt()}",
                  activeColor: Colors.blue,
                  onChanged: isRgbOn
                      ? (value) {
                          setState(() {
                            blue = value;
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ServoControlWidget extends StatefulWidget {
  const ServoControlWidget({Key? key}) : super(key: key);

  @override
  _ServoControlWidgetState createState() => _ServoControlWidgetState();
}

class _ServoControlWidgetState extends State<ServoControlWidget> {
  double servoPosition = 90; // Posição inicial do servo

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Controle do Servo",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Posição: ${servoPosition.toStringAsFixed(0)}°"),
                Slider(
                  value: servoPosition,
                  min: 0,
                  max: 180,
                  divisions: 180,
                  label: "${servoPosition.toStringAsFixed(0)}°",
                  onChanged: (value) {
                    setState(() {
                      servoPosition = value;
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

class LcdControlWidget extends StatefulWidget {
  const LcdControlWidget({Key? key}) : super(key: key);

  @override
  _LcdControlWidgetState createState() => _LcdControlWidgetState();
}

class _LcdControlWidgetState extends State<LcdControlWidget> {
  bool isLcdOn = false;
  TextEditingController messageController = TextEditingController();
  String displayedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle do LCD"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Controle do LCD",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "LCD",
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: isLcdOn,
                  onChanged: (value) {
                    setState(() {
                      isLcdOn = value;
                      if (!isLcdOn) {
                        displayedMessage =
                            ""; // Apaga a mensagem ao desligar o LCD
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLcdOn) ...[
              TextField(
                controller: messageController,
                maxLength: 32, // Limite de caracteres típico de um LCD
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Mensagem para o LCD",
                  hintText: "Digite a mensagem aqui",
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayedMessage = messageController.text;
                  });
                },
                child: const Text("Exibir Mensagem"),
              ),
              const SizedBox(height: 16),
              Text(
                "Mensagem no LCD:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[600],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Text(
                  displayedMessage,
                  style: const TextStyle(
                    color: Colors.green,
                    fontFamily: "Courier",
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else
              const Center(
                child: Text(
                  "LCD está desligado",
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
