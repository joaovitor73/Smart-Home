import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/ui/widgets/routineSection.dart';

class RoutineConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rotinas Automatizadas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuração de Rotinas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            buildRoutineSection(
              context,
              title: 'Quando presente',
              routines: [
                {'item': 'Luz', 'action': 'Ligar'},
                {'item': 'Cortina', 'action': 'Abrir'},
                {'item': 'Ar-condicionado', 'action': '22°C'},
              ],
            ),
            SizedBox(height: 20),
            buildRoutineSection(
              context,
              title: 'Quando ausente',
              routines: [
                {'item': 'Luz', 'action': 'Desligar'},
                {'item': 'Cortina', 'action': 'Fechar'},
                {'item': 'Ar-condicionado', 'action': 'Desligar'},
              ],
            ),
          ],
        ),
      ),
    );
  }
}
