import 'package:flutter_task_manager/model/services/sign_up_service.dart';

class SignUpRepository {
  SignUpRepository({required SignUpService signUpService})
    : _signUpService = signUpService;

  final SignUpService _signUpService;

  Future<void> signUp(String email, String password) async {
    try {
      await _signUpService.signUp(email, password);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
