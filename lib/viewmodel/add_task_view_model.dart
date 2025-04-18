import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';


class AddTaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  String? _errorMessage;
  DateTime? _selectedDate;
  bool _isLoading = false;

  AddTaskViewModel({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository();

  /// Error message to display in the UI, if any.
  String? get errorMessage => _errorMessage;

  /// Selected due date for the task.
  DateTime? get selectedDate => _selectedDate;

  /// Whether the task is currently being added.
  bool get isLoading => _isLoading;

  /// Sets the selected due date and notifies listeners.
  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Adds a new task to the repository.
  /// Returns true if successful, false otherwise.
  Future<bool> addTask(String title, String? description, DateTime? dueDate) async {
    if (title.isEmpty) {
      _errorMessage = AppConstants.errorTitleRequired;
      notifyListeners();
      return false;
    }

    final task = TaskEntity(
      title: title,
      description: description,
      dueDate: dueDate,
    );

    try {
      _isLoading = true;
      notifyListeners();
      await _taskRepository.addTask(task);
      _errorMessage = null;
      _selectedDate = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('AddTaskViewModel.addTask error: $e');
      }
      _errorMessage = AppConstants.errorTaskAdd;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resets the ViewModel state to clear form data.
  void reset() {
    _errorMessage = null;
    _selectedDate = null;
    _isLoading = false;
    notifyListeners();
  }
}