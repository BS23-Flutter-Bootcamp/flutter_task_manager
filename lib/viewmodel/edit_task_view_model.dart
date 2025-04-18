import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';
import 'package:flutter_task_manager/model/task.dart';

class EditTaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  String? _errorMessage;
  DateTime? _selectedDate;
  Task? _task;

  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;
  Task? get task => _task;

  // Initialize with the task to be edited without notifying listeners
  void init(Task task) {
    _task = task;
    _selectedDate = task.dueDate;
    _errorMessage = null;
    // Remove notifyListeners() to avoid rebuild during build phase
  }

  // Update the selected date
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Update the task
  Future<bool> updateTask(String title, String? description, DateTime? dueDate) async {
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

    final updatedTask = Task(
      id: _task!.id,
      title: title,
      description: description,
      dueDate: dueDate,
      isCompleted: _task!.isCompleted,
    );

    try {
      await _taskRepository.updateTask(updatedTask);
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
    if (_task == null || _task!.id == null) {
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