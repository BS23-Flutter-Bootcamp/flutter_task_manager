import 'package:flutter_task_manager/model/services/sign_up_service.dart';

class SignUpRepository {
  final SignUpService _service = SignUpService();

  Future<void> signUp(String email, String password) async {
    try {
      await _service.signUp(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
