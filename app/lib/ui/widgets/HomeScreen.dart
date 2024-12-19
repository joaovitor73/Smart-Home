import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorProvider with ChangeNotifier {
  final databaseRef = FirebaseDatabase.instance.ref();

  Map<String, String> _sensorData = {
    'livingRoomLight': "Carregando...",
    'banheiroLuz': "Carregando...",
    'cozinhaHumidade': "Carregando...",
    'cozinhaTemp': "Carregando...",
    'cozinhaLuz': "Carregando...",
    'quartoUmidade': "Carregando...",
    'quartoTemp': "Carregando...",
    'quartoLuz': "Carregando...",
  };

  Map<String, String> get sensorData => _sensorData;

  SensorProvider() {
    _listenToRealtimeChanges();
  }

  void _listenToRealtimeChanges() {
    _updateSensor(
        'livingRoomLight', "smart_home/json/comodos/sala/sensores/luz/valor");
    _updateSensor(
        'banheiroLuz', "smart_home/json/comodos/banheiro/sensores/luz/valor");
    _updateSensor('cozinhaHumidade',
        "smart_home/json/comodos/cozinha/sensores/umidade/valor");
    _updateSensor('cozinhaTemp',
        "smart_home/json/comodos/cozinha/sensores/temperatura/valor");
    _updateSensor(
        'cozinhaLuz', "smart_home/json/comodos/cozinha/sensores/luz/valor");
    _updateSensor('quartoUmidade',
        "smart_home/json/comodos/quarto/sensores/umidade/valor");
    _updateSensor('quartoTemp',
        "smart_home/json/comodos/quarto/sensores/temperatura/valor");
    _updateSensor(
        'quartoLuz', "smart_home/json/comodos/quarto/sensores/luz/valor");
  }

  void _updateSensor(String key, String path) {
    databaseRef.child(path).onValue.listen((event) {
      final data = event.snapshot.value;
      _sensorData[key] = data != null ? data.toString() : "N/A";
      notifyListeners();
    });
  }
}
