import 'package:app/services/realtime_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final realtime_service = RealtimeService();

    return ConfigureProviders(providers: [
      Provider<RealtimeService>.value(value: realtime_service),
    ]);
  }
}
