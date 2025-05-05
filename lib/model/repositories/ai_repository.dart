import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/services/ai_service.dart';

class AiRepository {
  AiRepository({AIService? aiService}) : _aiService = aiService ?? AIService();

  final AIService _aiService;

  Future<List<TaskEntity>> generateTaskPlan(String userPrompt) async {
    try {
      return await _aiService.generateTaskPlan(userPrompt);
    } catch (e) {
      throw Exception('Failed to generate task plan');
    }
  }
}
