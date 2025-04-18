import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';

/// ViewModel for managing the list of tasks, including fetching and updating tasks.
class TaskListViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  List<TaskEntity> _tasks = [];
  bool _isLoading = false;

  TaskListViewModel({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository();

  /// List of tasks to display.
  List<TaskEntity> get tasks => _tasks;

  /// Whether tasks are currently being fetched or updated.
  bool get isLoading => _isLoading;

  /// Fetches all tasks from the repository.
  Future<void> fetchTasks() async {
    try {
      _isLoading = true;
      notifyListeners();
      _tasks = await _taskRepository.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('TaskListViewModel.fetchTasks error: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles the completion status of a task.
  Future<void> toggleTaskCompletion(TaskEntity task) async {
    try {
      final updatedTask = TaskEntity(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: !task.isCompleted,
      );
      await _taskRepository.updateTask(updatedTask);
      _tasks = _tasks.map((t) => t.id == task.id ? updatedTask : t).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('TaskListViewModel.toggleTaskCompletion error: $e');
      }
    }
  }

  /// Deletes a task by ID.
  Future<void> deleteTask(int id) async {
    try {
      await _taskRepository.deleteTask(id);
      _tasks = _tasks.where((t) => t.id != id).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('TaskListViewModel.deleteTask error: $e');
      }
    }
  }
}