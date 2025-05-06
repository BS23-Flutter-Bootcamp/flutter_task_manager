import 'package:flutter_task_manager/model/services/login_service.dart';

class LoginRepository {
  LoginRepository({required LoginService loginService})
    : _loginService = loginService;

  final LoginService _loginService;

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      await _loginService.signIn(
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
      await _loginService.logOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isValidUser() async {
    try {
      final rememberMe = await _loginService.isRememberMeEnabled();
      final user = _loginService.currentUser;
      return user != null && rememberMe;
    } catch (e) {
      return false;
    }
  }
}
