import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Failed to log in: $e');
    }
  }
}