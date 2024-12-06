import 'package:app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final auth_service = AuthService();

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: auth_service),
    ]);
  }
}
