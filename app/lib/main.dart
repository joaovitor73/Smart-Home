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

  late GeoLocatorService geoLocatorService;
  late RealtimeService realtimeService;
  @override
  void initState() {
    super.initState();
    geoLocatorService = Provider.of<GeoLocatorService>(context, listen: false);
    realtimeService = Provider.of<RealtimeService>(context, listen: false);
    geoLocatorService.captureLocation();
    getValoresSensorComodo("sala", "luz");
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
                Sensor sensor = Sensor(
                  comodo: "sala",
                  nome: "luz",
                  dados: {"valor": newValue},
                );
                if (newValue.isNotEmpty) {
                  realtimeService.updateData(sensor: sensor);
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

  //pega os valores de um sensor de um comodo
  void getValoresSensorComodo(String comodo, String sensor) {
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .child(comodo)
        .child("sensores")
        .child(sensor)
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        fetchedData = data.toString();
      });
    });
  }

  //pega todos os sensores de um comodo
  void getSensoresComodo(String comodo) {
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .child(comodo)
        .child("sensores")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        fetchedData = data.toString();
      });
    });
  }

  //pega todos os comodos
  void getComodos() {
    databaseRef
        .child("smart_home")
        .child("json")
        .child("comodos")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        fetchedData = data.toString();
      });
    });
  }
}
