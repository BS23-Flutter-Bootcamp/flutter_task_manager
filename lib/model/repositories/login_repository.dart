import 'package:flutter_task_manager/model/services/login_service.dart';

class LoginRepository {
  
  LoginRepository({required LoginService loginService}) : _service = loginService;

   final LoginService _service;

  Future<void> isRegistered() async {
    try {
      await _service.initializePref();
      await _service.checkRememberMeStatus();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login({
    required email,
    required String password,
    required rememberMe,
  }) async {
    try {
      await _service.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _service.logOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
