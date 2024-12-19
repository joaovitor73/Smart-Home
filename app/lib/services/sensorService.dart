import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorDataProvider extends ChangeNotifier {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  final Map<String, String> _fetchedData = {};

  Map<String, String> get fetchedData => _fetchedData;

  void fetchSensorData(String comodo, String sensor) {
    final path = "smart_home/json/comodos/$comodo/sensores/$sensor";

    _databaseRef.child(path).onValue.listen((event) {
      final data = event.snapshot.value;
      _fetchedData["$comodo/$sensor"] = data.toString();
      notifyListeners();
    });
  }
}
