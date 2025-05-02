import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/repositories/login_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginRepository _repository = LoginRepository();
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isRememberMeChecked = false;
  bool _showPassword = false;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isRememberMeChecked => _isRememberMeChecked;
  bool get showPassword => _showPassword;
  String get email => _email;
  String get password => _password;

  bool get isFormValid =>
      _email.isNotEmpty &&
      _password.isNotEmpty &&
      _emailError == null &&
      _passwordError == null;

  void setEmail(String value) {
    _email = value.trim();
    _validateEmail();
    _clearGeneralError();
    notifyListeners();
  }

  void togglePasswordVisibility(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    _clearGeneralError();
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _isRememberMeChecked = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
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
    } else {
      _passwordError = null;
    }
  }

  void _clearGeneralError() {
    _errorMessage = null;
  }

  Future<bool> login() async {
    if (!isFormValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.login(
        email: _email,
        password: _password,
        rememberMe: _isRememberMeChecked,
      );
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

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.logout();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to log out. Please try again';
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapFirebaseErrorToMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email format';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else {
      return 'Failed to log in. Please try again';
    }
  }
}
