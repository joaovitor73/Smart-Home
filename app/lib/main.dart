import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/ui/widgets/HomeScreen.dart';
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instance.ref();
  String fetchedData = "Carregando dados...";
  final TextEditingController _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenToRealtimeChanges();
  }

  void listenToRealtimeChanges() {
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .child("sala")
        .child("sensores")
        .child("luz")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        _message = 'Login realizado com sucesso!';
      });
    } catch (e) {
      setState(() {
        _message = 'Erro ao fazer login: $e';
      });
    });
  }

  Future<void> updateLightValue(String value) async {
    try {
      await databaseRef
          .child("smart_home")
          .child("json")
          .child("comodos")
          .child("sala")
          .child("sensores")
          .child("luz")
          .update({
        "valor": value,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Valor atualizado com sucesso!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar o valor: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Realtime Database")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dados em tempo real: $fetchedData",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: "Novo valor para luz",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number, // Apenas números
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newValue = _valueController.text;
                if (newValue.isNotEmpty) {
                  updateLightValue(newValue);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Por favor, insira um valor válido")),
                  );
                }
              },
              child: Text("Atualizar Valor"),
            ),
          ],
        ),
      ),
    );
  }
}
