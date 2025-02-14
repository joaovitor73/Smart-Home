import 'package:app/services/sensorService.dart';
import 'package:app/services/geolocator_service.dart';
import 'package:app/services/notification_service.dart';
import 'package:app/services/realtime_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final realtime_service = RealtimeService();
    final notification_service = NotificationService(topic: "alerta");
    final geolocator_service = GeoLocatorService();
    final SensorDataProvider sensor_service = SensorDataProvider();

    return ConfigureProviders(providers: [
      Provider<RealtimeService>.value(value: realtime_service),
      Provider<NotificationService>.value(value: notification_service),
      ChangeNotifierProvider<GeoLocatorService>.value(
          value: geolocator_service),
      ChangeNotifierProvider<SensorDataProvider>.value(value: sensor_service),
    ]);
  }
}
