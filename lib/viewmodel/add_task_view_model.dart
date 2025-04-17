import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';
import 'package:flutter_task_manager/model/task.dart';


class AddTaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  String? _errorMessage;
  DateTime? _selectedDate;

  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<bool> addTask(String title, String? description, DateTime? dueDate) async {
    if (title.isEmpty) {
      _errorMessage = 'Title is required';
      notifyListeners();
      return false;
    }

    final task = Task(
      title: title,
      description: description,
      dueDate: dueDate,
    );

    try {
      await _taskRepository.addTask(task);
      _errorMessage = null;
      _selectedDate = null; // Reset date after adding
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add task';
      notifyListeners();
      return false;
    }
  }
}