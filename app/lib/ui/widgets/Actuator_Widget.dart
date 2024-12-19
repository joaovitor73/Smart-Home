import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:app/services/shared_service.dart';
import 'package:flutter/material.dart';

class ActuatorControlWidget extends StatefulWidget {
  final String actuatorName; // Nome do atuador (ex.: "Luz", "Motor")
  final IconData icon; // Ícone a ser exibido
  final String comodo;
  final String rotina;

  const ActuatorControlWidget({
    super.key,
    required this.actuatorName,
    required this.icon,
    required this.comodo,
    required this.rotina,
  });

  @override
  State<ActuatorControlWidget> createState() => _ActuatorControlWidgetState();
}

class _ActuatorControlWidgetState extends State<ActuatorControlWidget> {
  bool isOn = false; // Estado do atuador (ligado/desligado)
  double power = 0;
  RealtimeService realtimeService = RealtimeService();
  SharedService sharedService = SharedService();

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
                      widget.rotina != ""
                          ? SharedService.salvarSensor(
                              widget.rotina,
                              Sensor(
                                  comodo: widget.comodo.toString(),
                                  nome: widget.actuatorName,
                                  dados: {"valor": power}),
                            )
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
