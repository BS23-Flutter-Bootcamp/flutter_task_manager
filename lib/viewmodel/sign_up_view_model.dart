import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/repositories/sign_up_repository.dart';

class SignUpViewModel extends ChangeNotifier {

    SignUpViewModel({required SignUpRepository signUpRepository})
    : _signUpRepository = signUpRepository;

  final SignUpRepository _signUpRepository;
 


  String _email = '';
  String _password = '';
  String _repeatPassword = '';
  String? _emailError;
  String? _passwordError;
  String? _repeatPasswordError;
  String? _errorMessage;
  bool _isLoading = false;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get repeatPasswordError => _repeatPasswordError;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool get isFormValid =>
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _repeatPassword.isNotEmpty &&
      _emailError == null &&
      _passwordError == null &&
      _repeatPasswordError == null;

  void setEmail(String value) {
    _email = value.trim();
    _validateEmail();
    _clearGeneralError();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    _validateRepeatPassword();
    _clearGeneralError();
    notifyListeners();
  }

  void setRepeatPassword(String value) {
    _repeatPassword = value;
    _validateRepeatPassword();
    _clearGeneralError();
    notifyListeners();
  }

  void _validateEmail() {
    if (_email.isEmpty) {
      _emailError = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email)) {
      _emailError = 'Enter a valid email';
    } else {
      _emailError = null;
    }
  }

  void _validatePassword() {
    if (_password.isEmpty) {
      _passwordError = 'Password is required';
    } else if (_password.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
    } else {
      _passwordError = null;
    }
  }

  void _validateRepeatPassword() {
    if (_repeatPassword.isEmpty) {
      _repeatPasswordError = 'Please repeat password';
    } else if (_repeatPassword != _password) {
      _repeatPasswordError = 'Passwords do not match';
    } else {
      _repeatPasswordError = null;
    }
  }

  void _clearGeneralError() {
    _errorMessage = null;
  }

  Future<bool> signUp() async {
    if (!isFormValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _signUpRepository.signUp(_email, _password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _mapFirebaseErrorToMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _mapFirebaseErrorToMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email format';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else {
      return 'Failed to sign up. Please try again';
    }
  }
}
