import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

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
      if (kDebugMode) {
        print('SharedPreferences initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize SharedPreferences: $e');
      }
      // Don't rethrow - allow the app to continue without preferences
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      // First attempt authentication
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If authentication successful, try to save preference
      if (userCredential.user != null) {
        try {
          await init(); // Try to initialize if not already done
          await _prefs?.setBool(_rememberMeKey, rememberMe);
        } catch (e) {
          // Log but don't fail the sign in
          if (kDebugMode) {
            print('Failed to save remember me preference: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      rethrow; // Rethrow to allow UI to handle the error
    }
  }

  Future<bool> isRememberMeEnabled() async {
    try {
      await init(); // Try to initialize if not already done
      return _prefs?.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking remember me status: $e');
      }
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      try {
        await _prefs?.setBool(_rememberMeKey, false);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to clear remember me preference: $e');
        }
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
      if (kDebugMode) {
        print('Failed to check remember me status: $e');
      }
    }
  }

}
