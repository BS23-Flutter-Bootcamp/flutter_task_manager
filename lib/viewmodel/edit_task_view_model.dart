import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EditTaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;
  String _title = '';
  String? _description;
  DateTime? _dueDate;
  String? _errorMessage;
  TaskEntity? _task;
  bool _isLoading = false;

  EditTaskViewModel({TaskRepository? repository, TaskEntity? task})
      : _repository = repository ?? TaskRepository(),
        _task = task {
    if (task != null) {
      _title = task.title;
      _description = task.description;
      _dueDate = task.dueDate;
    }
  }

  String? get errorMessage => _errorMessage;
  TaskEntity? get task => _task;
  String get title => _title;
  String? get description => _description;
  DateTime? get dueDate => _dueDate;
  bool get isLoading => _isLoading;

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setDescription(String? value) {
    _description = value;
    notifyListeners();
  }

  void setDueDate(DateTime? value) {
    _dueDate = value;
    notifyListeners();
  }

  Future<bool> updateTask() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final email = FirebaseAuth.instance.currentUser?.email;
      if (email == null) throw Exception('User not authenticated');
      if (_task == null) throw Exception('No task to update');
      if (_title.trim().isEmpty) throw Exception('Title is required');

      final updatedTask = TaskEntity(
        id: _task!.id,
        title: _title.trim(),
        description: _description?.trim(),
        dueDate: _dueDate,
        isCompleted: _task!.isCompleted,
        lastSyncTime: DateTime.now(),
        email: email,
      );
      await _repository.updateTask(updatedTask);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.contains(ConnectivityResult.none);
      _errorMessage = isOffline
          ? 'Task updated locally. Sync when online.'
          : 'Failed to update task: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_task == null) throw Exception('No task to delete');
      await _repository.deleteTask(_task!.id!);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
            final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline =connectivityResult.contains(ConnectivityResult.none);
      _errorMessage = isOffline
          ? 'Task deleted locally. Sync when online.'
          : 'Failed to delete task: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}