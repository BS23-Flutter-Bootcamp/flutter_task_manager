import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';
import 'package:flutter_task_manager/model/services/ai_service.dart';

class AiViewModel extends ChangeNotifier {
  final AIService _aiService;

  AiViewModel({AIService? aiService, TaskRepository? taskRepository})
    : _aiService = aiService ?? AIService();

  String _prompt = '';
  List<TaskEntity> _generatedTasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  String get prompt => _prompt;
  List<TaskEntity> get generatedTasks => _generatedTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setPrompt(String value) {
    _prompt = value;
    _errorMessage = null;
    notifyListeners();
  }

  void updateTask(int index, TaskEntity updatedTask) {
    if (index >= 0 && index < _generatedTasks.length) {
      _generatedTasks[index] = updatedTask;
      notifyListeners();
    }
  }

  Future<void> generateTasks() async {
    if (_prompt.isEmpty) {
      _errorMessage = 'Please enter a prompt';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      _generatedTasks = await _aiService.generateTaskPlan(_prompt);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to generate tasks: $e';
      notifyListeners();
    }
  }

  Future<void> saveTasks() async {
    if (_generatedTasks.isEmpty) {
      _errorMessage = 'No tasks to save';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _generatedTasks = [];
      _prompt = '';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to save tasks: $e';
      if (kDebugMode) {
        print('Save Tasks Error: $e');
      }
      notifyListeners();
    }
  }
}
