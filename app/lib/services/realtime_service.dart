import 'package:firebase_database/firebase_database.dart';

class RealtimeService {
  get realtimeService => null;

  Future<void> updateData({
    required String comodo,
    required String sensor,
    required Map<String, dynamic> keyValuePairs,
  }) async {
    final databaseRef = FirebaseDatabase.instance
        .ref('smart_home/json/comodos/$comodo/sensores/$sensor');

    try {
      await databaseRef.update(keyValuePairs);
      print('Atualização realizada com sucesso!');
    } catch (error) {
      print('Erro ao atualizar: $error');
    }
  }
}
