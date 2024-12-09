import 'package:app/core/configure_providers.dart';
import 'package:app/ui/widgets/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final providers = await ConfigureProviders.createDependencyTree();

  runApp(
    MultiProvider(
      providers: providers.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthTestScreen(),
    );
  }
}

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({Key? key}) : super(key: key);

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _register(AuthService authService) async {
    try {
      await authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() {
        _message = 'Usuário registrado com sucesso!';
      });
    } catch (e) {
      setState(() {
        _message = 'Erro ao registrar: $e';
      });
    }
  }

  Future<void> _login(AuthService authService) async {
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() {
        _message = 'Login realizado com sucesso!';
      });
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _message = 'Erro ao fazer login: $e';
      });
    }
  }

  Future<void> _resetPassword(AuthService authService) async {
    try {
      await authService.resetPassword(_emailController.text.trim());
      setState(() {
        _message = 'E-mail de recuperação enviado!';
      });
    } catch (e) {
      setState(() {
        _message = 'Erro ao enviar e-mail de recuperação: $e';
      });
    }
  }

  Future<void> _logout(AuthService authService) async {
    try {
      await authService.signOut();
      setState(() {
        _message = 'Logout realizado com sucesso!';
      });
    } catch (e) {
      setState(() {
        _message = 'Erro ao fazer logout: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Teste de Firebase Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _register(authService),
              child: const Text('Registrar'),
            ),
            ElevatedButton(
              onPressed: () => _login(authService),
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => _resetPassword(authService),
              child: const Text('Redefinir Senha'),
            ),
            ElevatedButton(
              onPressed: () => _logout(authService),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('Erro') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
