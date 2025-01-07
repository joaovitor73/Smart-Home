import 'dart:convert';

import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  // Instância do RealtimeService para interagir com o servidor
  static final RealtimeService realtimeService = RealtimeService();

  // Função para salvar um sensor
  static Future<void> salvarSensor(String rotina, Sensor sensor) async {
    final prefs = await SharedPreferences.getInstance();

    // Recupera a lista de sensores já existentes ou cria uma nova lista se não houver
    List<String> sensoresExistentes = prefs.getStringList(rotina) ?? [];

    // Adiciona o novo sensor à lista
    sensoresExistentes.add(jsonEncode(sensor.toJson()));

    // Salva a lista de sensores no SharedPreferences
    await prefs.setStringList(rotina, sensoresExistentes);
  }

  // Função para recuperar sensores da rotina
  static Future<List<Sensor>> recuperarSensores(String rotina) async {
    if (rotina == "casa") {
      await realtimeService.updateAusencia(estado: 0);
    } else {
      await realtimeService.updateAusencia(estado: 1);
    }

    final prefs = await SharedPreferences.getInstance();

    // Recupera os sensores salvos para a rotina especificada
    List<String> sensoresJson = prefs.getStringList(rotina) ?? [];

    // Atualiza os dados no servidor
    for (var sensorJson in sensoresJson) {
      Sensor sensor = Sensor.fromJson(jsonDecode(sensorJson));
      await realtimeService.updateData(sensor: sensor);
    }

    // Converte os dados dos sensores para objetos Sensor
    return sensoresJson.map((sensorJson) {
      return Sensor.fromJson(jsonDecode(sensorJson));
    }).toList();
  }

  // Função para remover um sensor da rotina
  static Future<void> removerSensor(String rotina, Sensor sensor) async {
    final prefs = await SharedPreferences.getInstance();

    // Recupera os sensores existentes para a rotina
    List<String> sensoresExistentes = prefs.getStringList(rotina) ?? [];

    // Remove o sensor da lista
    sensoresExistentes.removeWhere((sensorJson) {
      Sensor existingSensor = Sensor.fromJson(jsonDecode(sensorJson));
      return existingSensor.nome ==
          sensor.nome; // Verifica se o nome do sensor é igual
    });

    // Salva novamente a lista de sensores sem o sensor removido
    await prefs.setStringList(rotina, sensoresExistentes);
  }
}
