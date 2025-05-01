import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';

class TaskListViewModel extends ChangeNotifier {
  TaskListViewModel({TaskRepository? repository})
    : _repository = repository ?? TaskRepository();

  final TaskRepository _repository;

  List<TaskEntity> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TaskEntity> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTasks({bool sync = false}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (sync) {
        await _repository.syncTasks();
      }

      // Always fetch from local SQLite
      _tasks = await _repository.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Offline mode - showing local data';
      _isLoading = false;
      notifyListeners();

      // Attempt to load local tasks even on error
      try {
        _tasks = await _repository.getTasks();
      } catch (_) {
        _tasks = [];
      }
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    try {
      final updatedTask = TaskEntity(
        id: task.id ?? 0,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: !task.isCompleted,
        lastSyncTime: DateTime.now(),
        email: task.email,
      );
      await _repository.updateTask(updatedTask);
      _tasks = await _repository.getTasks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      notifyListeners();
    }
  }
}
