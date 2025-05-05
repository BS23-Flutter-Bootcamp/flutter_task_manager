import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/repositories/ai_repository.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';

class AiViewModel extends ChangeNotifier {
  AiViewModel({AiRepository? aiRepository, TaskRepository? taskRepository})
    : _aiRepository = aiRepository ?? AiRepository(),
      _taskRepository = taskRepository ?? TaskRepository();

  String _prompt = '';
  List<TaskEntity> _generatedTasks = [];
  bool _isGenerating = false;
  bool _isSaving = false;
  String? _errorMessage;
  final AiRepository _aiRepository;
  final TaskRepository _taskRepository;

  String get prompt => _prompt;
  List<TaskEntity> get generatedTasks => _generatedTasks;
  bool get isGenerating => _isGenerating;
  String? get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;

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
      _isGenerating = true;
      _errorMessage = null;
      notifyListeners();
      _generatedTasks = await _aiRepository.generateTaskPlan(_prompt);
      _isGenerating = false;
      notifyListeners();
    } catch (e) {
      _isGenerating = false;
      _errorMessage = 'Failed to generate tasks';
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
      _isSaving = true;
      _errorMessage = null;
      notifyListeners();
      await _taskRepository.addTasksFromAI(_generatedTasks);
      _generatedTasks = [];
      _prompt = '';
      _isSaving = false;
      notifyListeners();
    } catch (e) {
      _isSaving = false;
      _errorMessage = 'Failed to save tasks';
      notifyListeners();
    }
  }
}
