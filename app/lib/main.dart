import 'package:app/ui/widgets/HomeScreen.dart';
import 'package:app/core/configure_providers.dart';
import 'package:app/domain/Sensor.dart';
import 'package:app/services/geolocator_service.dart';
import 'package:app/services/realtime_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Cria o tree de dependências
  final configureProviders = await ConfigureProviders.createDependencyTree();

  await authenticateAdmin();

  runApp(
    MultiProvider(
      providers: configureProviders.providers,
      child: MyApp(),
    ),
  );
}

Future<void> authenticateAdmin() async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "adm@gmail.com",
      password: "admin123",
    );
    print("Autenticação bem-sucedida!");
  } catch (e) {
    print("Erro ao autenticar: $e");
    throw Exception("Falha na autenticação. Verifique as credenciais.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
