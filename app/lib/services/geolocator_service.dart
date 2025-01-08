import 'dart:async';

import 'package:app/services/shared_service.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocatorService extends ChangeNotifier {
  String isPresent = "";
  String valorAnterior = "";

  // Coordenadas da sua casa
  final double homeLatitude = -5.885995;
  final double homeLongitude = -35.363265;
  final double homeRadius = 5.0; // Raio de 5 metros em torno da casa

  Position? lastKnownPosition;

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
        distanceFilter: 0, // Força a atualização para cada mudança mínima
      ),
    ).listen((Position position) {
      captureLocation(position);
    });
  }

  Future<void> captureLocation(Position position) async {
    if (lastKnownPosition != null) {
      double distance = Geolocator.distanceBetween(
        lastKnownPosition!.latitude,
        lastKnownPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      if (distance < 1.0) {
        // Ignora pequenas mudanças (menos de 1 metro)
        return;
      }
    }

    lastKnownPosition = position;

    bool estaEmCasa = _verificarPresenca(
      position.latitude,
      position.longitude,
    );

    if (estaEmCasa && isPresent != "Presente") {
      ativarPresencao(true);
    } else if (!estaEmCasa && isPresent != "Ausente") {
      ativarPresencao(false);
    }

    print("Posição: ${position.latitude}, ${position.longitude}");
    notifyListeners();
  }

  bool _verificarPresenca(double latitude, double longitude) {
    // Calcula a distância entre a posição atual e a posição da casa
    double distance = Geolocator.distanceBetween(
      homeLatitude,
      homeLongitude,
      latitude,
      longitude,
    );

    // Retorna true se estiver dentro do raio de 5 metros
    return distance <= homeRadius;
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
