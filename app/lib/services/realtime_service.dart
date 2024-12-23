import 'package:app/domain/Sensor.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeService {
  get realtimeService => null;

  Future<void> updateData({
    required Sensor sensor,
  }) async {
    String nome = sensor.nome;
    String comodo = sensor.comodo;
    final databaseRef = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/$comodo/sensores/$nome');

    try {
      await databaseRef.update(sensor.dados);
      print('Atualização realizada com sucesso!');
    } catch (error) {
      print('Erro ao atualizar: $error');
    }
  }

  Future<void> updateAusencia({
    required int estado,
  }) async {
    final databaseRef = FirebaseDatabase.instance.ref('smart_home/json');
    try {
      await databaseRef.update({'ausente': estado});
      print('Atualização realizada com sucesso!');
    } catch (error) {
      print('Erro ao atualizar: $error');
    }
  }

  Future<void> modoCabare() async {
    final databaseRef = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/quarto/sensores/');
    try {
      await databaseRef.update({
        'lcd': {'valor': 26},
        'led_rgb': {'r': 255, 'g': 0, 'b': 0},
        'motor': {'valor': 210},
        'temperatura': {'valor': 26}
      });
      print('Atualização realizada com sucesso!');
    } catch (error) {
      print('Erro ao atualizar: $error');
    }
  }
}
