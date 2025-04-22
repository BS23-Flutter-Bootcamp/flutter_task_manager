import 'package:flutter_task_manager/model/services/login_service.dart';


class LoginRepository {
  final LoginService _service = LoginService();

  Future<void> login(String email, String password) async {
    try {
      await _service.login(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}