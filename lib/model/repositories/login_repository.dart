import 'package:flutter_task_manager/model/services/login_service.dart';

class LoginRepository {
  
  LoginRepository({required LoginService loginService}) : _service = loginService;

  final LoginService _service;

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
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
