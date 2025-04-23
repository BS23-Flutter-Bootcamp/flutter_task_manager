import 'package:flutter/foundation.dart';
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

  Future<void> fetchTasks() async {
    try {
      _isLoading = true;
      notifyListeners();
      await _repository.syncTasks(); // Sync before fetching
      _tasks = await _repository.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load tasks: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    try {
      final updatedTask = TaskEntity(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: !task.isCompleted,
        lastSyncTime: DateTime.now(),
        email: task.email,
      );
      await _repository.updateTask(updatedTask);
      await _repository.syncTasks();
      _tasks = await _repository.getTasks();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      notifyListeners();
    }
  }
}