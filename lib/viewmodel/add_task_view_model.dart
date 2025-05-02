import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;
  String _title = '';
  String? _description;
  DateTime _dueDate = DateTime.now();
  String? _errorMessage;
  bool _isLoading = false;

  AddTaskViewModel({TaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  String? get errorMessage => _errorMessage;
  String get title => _title;
  String? get description => _description;
  DateTime get dueDate => _dueDate;
  bool get isLoading => _isLoading;

  void setTitle(String value) {
    _title = value.trim();
    notifyListeners();
  }

  void setDescription(String? value) {
    _description = value?.trim();
    notifyListeners();
  }

  void setDueDate(DateTime value) {
    _dueDate = value;
    notifyListeners();
  }

  Future<bool> addTask() async {
    try {
      _isLoading = true;
      notifyListeners();
      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) throw Exception('User not authenticated');
      if (_title.isEmpty) throw Exception('Title is required');
      final task = TaskEntity(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        isCompleted: false,
        lastSyncTime: DateTime.now(),
        email: email,
      );
      await _repository.addTask(task); 
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add task: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}