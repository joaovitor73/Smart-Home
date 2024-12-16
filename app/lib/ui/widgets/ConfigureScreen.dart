import 'package:flutter/material.dart';

class ConfigurationScreen extends StatelessWidget {
  final String roomName;

  const ConfigurationScreen({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurar $roomName"),
      ),
      body: Center(
        child: Text("Tela de configuração para $roomName"),
      ),
    );
  }
}
