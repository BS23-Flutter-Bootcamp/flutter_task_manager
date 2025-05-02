import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/services/ai_service.dart';

class AiRepository {
  final AIService _aiService;

  AiRepository({AIService? aiService}) : _aiService = aiService ?? AIService();

  /// Generates a task plan based on the user prompt
  Future<List<TaskEntity>> generateTaskPlan(String userPrompt) async {
    try {
      return await _aiService.generateTaskPlan(userPrompt);
    } catch (e) {
      throw Exception('Failed to generate task plan');
    }
  }
}