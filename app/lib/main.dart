import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase

  // Autenticação automática com as credenciais fixas
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
  final databaseRef =
      FirebaseDatabase.instance.ref(); // Referência ao banco de dados
  String fetchedData = "Carregando dados...";

  @override
  void initState() {
    super.initState();
    listenToRealtimeChanges(); // Escuta as alterações em tempo real
  }

  void listenToRealtimeChanges() {
    // Escuta as mudanças em tempo real no nó "smart_home/json/comodos/sala/sensores"
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .child("sala")
        .child("sensores")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        fetchedData =
            data.toString(); // Atualiza o estado com os dados alterados
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Realtime Database")),
      body: Center(
        child: Text(fetchedData),
      ),
    );
  }
}
