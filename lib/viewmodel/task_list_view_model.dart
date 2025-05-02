import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';

class TaskListViewModel extends ChangeNotifier {
  TaskListViewModel({TaskRepository? repository, TaskEntity? task})
    : _repository = repository ?? TaskRepository(),
      _task = task {
    if (task != null) {
      _title = task.title;
      _description = task.description;
      _dueDate = task.dueDate;
    }
  }
  final TaskRepository _repository;

  List<TaskEntity> _tasks = [];
  String? _errorMessage;
  bool _isLoading = false;
  final TaskEntity? _task;
  String _title = '';
  String? _description;
  DateTime? _dueDate;

  String? get errorMessage => _errorMessage;
  TaskEntity? get task => _task;
  String get title => _title;
  String? get description => _description;
  DateTime? get dueDate => _dueDate;
  bool get isLoading => _isLoading;

  List<TaskEntity> get tasks => _tasks;

  Future<void> fetchTasks({bool sync = false}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (sync) {
        await _repository.syncTasks();
      }

      _tasks = await _repository.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Offline mode - showing local data';
      _isLoading = false;
      notifyListeners();

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

  Future<bool> deleteTask({required int? id}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (id == null) throw Exception('No task to delete');
      await _repository.deleteTask(id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.contains(ConnectivityResult.none);
      _errorMessage =
          isOffline
              ? 'Task deleted locally. Sync when online.'
              : 'Failed to delete task: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
