import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const String _rememberMeKey = 'remember_me';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static SharedPreferences? _prefs;

  User? get currentUser => _auth.currentUser;

  // Initialize SharedPreferences
  Future<void> init() async {
    if (_prefs != null) return;

    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      throw Exception('Failed to initialize SharedPreferences');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          await init(); 
          await _prefs?.setBool(_rememberMeKey, rememberMe);
        } catch (e) {
          throw Exception('Failed to save remember me preference');
        }
      }
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  Future<bool> isRememberMeEnabled() async {
    try {
      await init(); 
      return _prefs?.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      try {
        await _prefs?.setBool(_rememberMeKey, false);
      } catch (e) {
        throw Exception('Failed to clear remember me preference');
      }
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<void> checkRememberMeStatus() async {
    try {
      final rememberMe = await isRememberMeEnabled();
      final user = currentUser;

      if (!rememberMe && user != null) {
        await logOut();
      }
    } catch (e) {
      throw Exception('Failed to check remember me status');
    }
  }
}
