import 'package:app/domain/Sensor.dart';
import 'package:app/services/shared_service.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  String latitudeCasa = "-5.8950000";
  String longitudeCasa = "-35.630000";

  Future<Position> determinePosition() async {
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

    return await Geolocator.getCurrentPosition();
  }

  //definir maior igual para quando quiser que a localização fique em um local maior
  // definir igual quando quiser o local exato
  Future<void> captureLocation() async {
    Sensor s = Sensor(
      comodo: 'sala',
      nome: 'luz',
      dados: {
        'valor': 123123,
      },
    );

    SharedService.salvarSensor('fora_casa', s);

    Position? position = await determinePosition();
    if (position.latitude == latitudeCasa &&
        position.longitude == longitudeCasa) {
      SharedService.recuperarSensores('casa');
    } else {
      SharedService.recuperarSensores('fora_casa');
    }
    print("Posição: ${position.latitude}, ${position.longitude}");
  }
}
