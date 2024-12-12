import 'package:app/ui/widgets/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await authenticateAdmin();

  runApp(MyApp());
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

Widget _buildSensorCard(String label, String value) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      title: Text(label, style: TextStyle(fontSize: 18)),
      trailing:
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
    ),
  );
}
