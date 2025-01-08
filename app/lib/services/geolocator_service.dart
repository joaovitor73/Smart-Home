import 'dart:async';

import 'package:app/services/shared_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocatorService extends ChangeNotifier {
  String latitudeCasaX1 = "-5.8950000";
  String latitudeCasaX2 = "-5.8950000";
  String longitudeCasaY1 = "-35.630000";
  String longitudeCasaY2 = "-35.630000";
  String isPresent = ""; // Estado atual (Presente ou Ausente)
  String valorAnterior = ""; // Estado anterior

  GeoLocatorService() {
    requestPermission();
    _startListeningToLocation();
  }

  Future<void> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void _startListeningToLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    ).listen((Position position) {
      captureLocation(position);
    });
  }

  Future<void> captureLocation(Position position) async {
    // Verificar se o usuário está em casa
    bool estaEmCasa = _verificarPresenca(
      position.latitude,
      position.longitude,
    );

    // Atualizar estado apenas se houver mudança
    if (estaEmCasa && isPresent != "Presente") {
      ativarPresencao(true); // Usuário entrou em casa
    } else if (!estaEmCasa && isPresent != "Ausente") {
      ativarPresencao(false); // Usuário saiu de casa
    }

    print("Posição: ${position.latitude}, ${position.longitude}");
    notifyListeners();
  }

  bool _verificarPresenca(double latitude, double longitude) {
    // Lógica para verificar se está dentro das coordenadas da casa
    return (true);
  }

  void ativarPresencao(bool flag) {
    if (flag) {
      SharedService.recuperarSensores('Casa');
      isPresent = "Presente";
    } else {
      SharedService.recuperarSensores('Fora de Casa');
      isPresent = "Ausente";
    }
    valorAnterior = isPresent; // Atualiza o estado anterior
  }
}
