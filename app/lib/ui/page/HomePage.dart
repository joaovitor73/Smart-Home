// import 'package:app/core/configure_providers.dart';
// import 'package:app/core/sensorService.dart';
// import 'package:app/services/realtime_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'domain/Sensor.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final configureProviders = await ConfigureProviders.createDependencyTree();

//   await authenticateAdmin();
//   runApp(
//     MultiProvider(
//       providers: configureProviders.providers,
//       child: App(),
//     ),
//   );
// }

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

// Future<void> authenticateAdmin() async {
//   try {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: "adm@gmail.com",
//       password: "admin123",
//     );
//     print("Autenticação bem-sucedida!");
//   } catch (e) {
//     print("Erro ao autenticar: $e");
//     throw Exception("Falha na autenticação. Verifique as credenciais.");
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _salaLuzController = TextEditingController();
//   final TextEditingController _cozinhaTemperaturaController =
//       TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final sensorDataProvider =
//           Provider.of<SensorDataProvider>(context, listen: false);

//       final sensors = [
//         {"comodo": "sala", "sensor": "luz"},
//         {"comodo": "cozinha", "sensor": "temperatura"},
//       ];

//       for (var sensor in sensors) {
//         sensorDataProvider.fetchSensorData(
//             sensor['comodo']!, sensor['sensor']!);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final fetchedData = Provider.of<SensorDataProvider>(context).fetchedData;

//     final RealtimeService realtimeService =
//         Provider.of<RealtimeService>(context);

//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Smart Home'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Sala - Luz: ${fetchedData['sala/luz']?.toString() ?? 'Sem dados'}',
//                 style: TextStyle(fontSize: 24),
//               ),
//               TextField(
//                 controller: _salaLuzController,
//                 decoration: InputDecoration(labelText: 'Atualizar Sala - Luz'),
//                 keyboardType: TextInputType.number,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   String value = _salaLuzController.text;
//                   if (value.isNotEmpty) {
//                     Sensor sensor = Sensor(
//                       nome: 'luz',
//                       comodo: 'sala',
//                       dados: {'valor': value},
//                     );
//                     realtimeService.updateData(sensor: sensor);
//                   }
//                 },
//                 child: Text('Atualizar Sala - Luz'),
//               ),
//               SizedBox(height: 16), // Espaço entre os textos

//               SizedBox(height: 16), // Espaço entre os textos
//               Text(
//                 'Cozinha - Temperatura: ${fetchedData['cozinha/temperatura']?.toString() ?? 'Sem dados'}',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ],
//           ),
//         ));
//   }
// }
