import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/repositories/login_repository.dart';

class LoginViewModel extends ChangeNotifier {

  LoginViewModel({required LoginRepository loginRepository}): _loginRepository = loginRepository;
  
  final LoginRepository _loginRepository;

  String _email = '';
  String _password = '';
  String? _message;
  bool _isLoading = false;
  bool _isRememberMeChecked = false;
  bool _showPassword = false;

  String? get message => _message;
  bool get isLoading => _isLoading;
  bool get isRememberMeChecked => _isRememberMeChecked;
  bool get showPassword => _showPassword;
  String get email => _email;
  String get password => _password;

  Future<void> initialize() async {
  await _loginRepository.isRegistered();
}


  void setEmail(String value) {
    _email = value.trim();
    _clearMessage();
    notifyListeners();
  }

  void togglePasswordVisibility(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _clearMessage();
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

  void setMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  void _clearMessage() {
    _message = null;
  }

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loginRepository.login(
        email: _email,
        password: _password,
        rememberMe: _isRememberMeChecked,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _message = _mapFirebaseErrorToMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _loginRepository.logout();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _message = 'Failed to log out. Please try again';
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapFirebaseErrorToMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('user-disabled')) {
      return 'This account has been disabled';
    } else if (error.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else {
      return 'Failed to log in. Password or email is incorrect';
    }
  }
}
