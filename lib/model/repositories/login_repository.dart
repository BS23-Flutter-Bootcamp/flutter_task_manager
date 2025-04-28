import 'package:flutter_task_manager/model/services/login_service.dart';


class LoginRepository {
  final LoginService _service = LoginService();

  Future<void> login({required email,required String password,required rememberMe }) async {
    try {
      await _service.signIn(email: email, password: password, rememberMe: rememberMe);
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