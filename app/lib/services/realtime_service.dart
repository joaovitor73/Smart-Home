import 'package:app/domain/Sensor.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeService {
  Future<void> updateData({
    required Sensor sensor,
  }) async {
    print("Atualizando dados do sensor: ${sensor.nome}");
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

  // Future<void> updateAusencia({
  //   required int estado,
  // }) async {
  //   final databaseRef = FirebaseDatabase.instance.ref('smart_home/json');
  //   try {
  //     await databaseRef.update({'ausente': estado});
  //     print('Atualização realizada com sucesso!');
  //   } catch (error) {
  //     print('Erro ao atualizar: $error');
  //   }
  // }

  Future<void> modoCabareLigar() async {
    final databaseRef = FirebaseDatabase.instance.ref('smart_home/json');
    final motor = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/quarto/sensores/motor');
    final ar = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/quarto/sensores/lcd');
    try {
      await ar.update({'valor': 20});
      await motor.update({'valor': 120});
      await databaseRef.update({'r': "0,0,255,0"});
      print('Atualização realizada com sucesso!');
    } catch (error) {
      print('Erro ao atualizar: $error');
    }
  }

  Future<void> modoCabareDesligar() async {
    final databaseRef = FirebaseDatabase.instance.ref('smart_home/json');
    final motor = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/quarto/sensores/motor');
    final ar = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/quarto/sensores/lcd');
    try {
      await ar.update({'valor': 20});
      await motor.update({'valor': 0});
      await databaseRef.update({'r': "0,0,255,0"});
      print('Atualização realizada com sucesso!');
    } catch (error) {
      print('Erro ao atualizar: $error');
    }
  }
}
