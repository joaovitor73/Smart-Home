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
  final configureProviders = await ConfigureProviders.createDependencyTree();

  runApp(
    MultiProvider(
      providers: configureProviders.providers,
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

// ------------------- Tela de Login -------------------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _authenticateAdmin() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Se a autenticação for bem-sucedida, vá para a tela Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao autenticar. Verifique suas credenciais.";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 182, 255), // Cor azul de fundo
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bem-vindo!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Faça login para continuar",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),
                // Campo de E-mail
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Campo de Senha
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Senha",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Mensagem de erro, se houver
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
                // Botão de Login
                _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : ElevatedButton(
                        onPressed: _authenticateAdmin,
                        child: Text(
                          "Entrar",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Botão branco
                          foregroundColor:
                              Color.fromARGB(255, 10, 179, 252), // Texto azul
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- Tela Principal (Home) -------------------
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
    _fetchSensorData("sala", "luz");
  }

  // Função para buscar os valores do sensor de um cômodo
  void _fetchSensorData(String comodo, String sensor) {
    databaseRef
        .child("smart_home/json/comodos/$comodo/sensores/$sensor")
        .onValue
        .listen((event) {
      final data = event.snapshot.value;
      setState(() {
        fetchedData = data.toString();
      });
    });
  }

  // Atualiza valores do sensor
  void _updateSensorData() {
    final newValue = _valueController.text;
    if (newValue.isNotEmpty) {
      Sensor sensor = Sensor(
        comodo: "sala",
        nome: "luz",
        dados: {"valor": newValue},
      );
      realtimeService.updateData(sensor: sensor);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Valor atualizado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, insira um valor válido")),
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
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateSensorData,
              child: Text("Atualizar Valor"),
            ),
          ],
        ),
      ),
    );
  }
}
