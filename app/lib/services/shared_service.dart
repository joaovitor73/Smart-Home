import 'dart:convert';

import 'package:app/domain/Sensor.dart';
import 'package:app/services/realtime_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  // A rotina pode ser "casa" ou "fora_casa"
  // O sensor é o sensor que será salvo

  RealtimeService realtimeService = RealtimeService();
  static Future<void> salvarSensor(String rotina, Sensor sensor) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> sensoresExistentes = prefs.getStringList(rotina) ?? [];

    sensoresExistentes.add(jsonEncode(sensor.toJson()));

    await prefs.setStringList(rotina, sensoresExistentes);
  }

  static Future<List<Sensor>> recuperarSensores(String rotina) async {
    if (rotina == "casa") {
      await RealtimeService().updateAusencia(estado: 0);
    } else {
      await RealtimeService().updateAusencia(estado: 1);
    }
    final prefs = await SharedPreferences.getInstance();

    List<String> sensoresJson = prefs.getStringList(rotina) ?? [];

    for (var sensorJson in sensoresJson) {
      Sensor sensor = Sensor.fromJson(jsonDecode(sensorJson));
      await RealtimeService().updateData(sensor: sensor);
    }
    return sensoresJson.map((sensorJson) {
      return Sensor.fromJson(jsonDecode(sensorJson));
    }).toList();
  }
}
