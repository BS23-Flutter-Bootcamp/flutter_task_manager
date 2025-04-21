import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';

class EditTaskViewModel extends ChangeNotifier {
  EditTaskViewModel(TaskEntity task) : _task = task, _errorMessage = null;

  final TaskRepository _taskRepository = TaskRepository();
  TaskEntity? _task;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  TaskEntity? get task => _task;

  // Update the selected date
  void setSelectedDate(DateTime? date) {
    if (_task != null) {
      _task = TaskEntity(
        id: _task!.id,
        title: _task!.title,
        description: _task!.description,
        dueDate: date,
        isCompleted: _task!.isCompleted,
      );
      notifyListeners();
    }
  }

  // Update the task
  Future<bool> updateTask({
    required String title,
    String? description,
    required DateTime? dueDate,
  }) async {
    if (title.isEmpty) {
      _errorMessage = 'Title is required';
      notifyListeners();
      return false;
    }

    if (_task == null) {
      _errorMessage = 'No task to update';
      notifyListeners();
      return false;
    }

    final updatedTask = TaskEntity(
      id: _task?.id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: _task!.isCompleted,
    );

    try {
      await _taskRepository.updateTask(updatedTask);
      _task = updatedTask;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update task';
      notifyListeners();
      return false;
    }
  }

  // Delete the task
  Future<bool> deleteTask() async {
    if (_task == null || _task?.id == null) {
      _errorMessage = 'No task to delete';
      notifyListeners();
      return false;
    }

    try {
      await _taskRepository.deleteTask(_task!.id!);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete task';
      notifyListeners();
      return false;
    }
  }
}
