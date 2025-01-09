import 'package:app/core/configure_providers.dart';
import 'package:app/ui/page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final configureProviders = await ConfigureProviders.createDependencyTree();
  runApp(
    MultiProvider(
      providers: configureProviders.providers,
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
