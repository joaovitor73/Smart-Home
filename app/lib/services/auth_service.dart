import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
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

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('E-mail de recuperação enviado');
    } catch (e) {
      print('Erro ao enviar e-mail de recuperação: $e');
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  String? getCurrentUser() {
    return _firebaseAuth.currentUser!.email;
  }

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print('Erro ao fazer login anônimo: $e');
    }
  }
}
