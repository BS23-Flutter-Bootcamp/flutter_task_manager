import 'dart:convert';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AIService {
  final GenerativeModel _model;

  AIService()
    : _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      );

  Future<List<TaskEntity>> generateTaskPlan(String userPrompt) async {
    try {
      final currentDate = DateTime.now();
      final defaultDays = 7;
      final prompt = '''
Given the user request: "$userPrompt", create a to-do task plan with 3–5 tasks related to the request, organized by day (e.g., Day 1, Day 2). If the request specifies a number of days (e.g., "for 5 days"), distribute that number of tasks across those days, labeling each task with the corresponding day in the title (e.g., "Day 1: Task Title"). If no days are specified, distribute 3–5 tasks across the next $defaultDays days. Each task must have:
- A title (short, descriptive, max 50 characters, prefixed with "Day X: " where X is the day number).
- A description (1–2 sentences detailing the task).
- A due date (ISO 8601 format, e.g., "2025-05-01T14:00:00", within the specified or default $defaultDays days from today, ${currentDate.toIso8601String()}).
Output only a JSON array of objects. Example:
[
  {
    "title": "Day 1: Task 1",
    "description": "Description of task 1.",
    "dueDate": "2025-05-01T14:00:00"
  },
  {
    "title": "Day 2: Task 2",
    "description": "Description of task 2.",
    "dueDate": "2025-05-02T14:00:00"
  }
]
Ensure due dates are realistic, spread across the specified or default $defaultDays days, and in local time. If the prompt is vague, make reasonable assumptions to create relevant tasks.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw Exception('No response from AI model');
      }

      // Clean response to remove Markdown code blocks
      String cleanedResponse = response.text!.trim();
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.replaceFirst('```json', '').trim();
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse =
            cleanedResponse.replaceAll(RegExp(r'```$'), '').trim();
      }

      // Parse JSON response
      final jsonResponse = jsonDecode(cleanedResponse);
      if (jsonResponse is! List) {
        throw Exception('Invalid response format: Expected JSON array');
      }

      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) {
        throw Exception('User not authenticated');
      }

      // Convert to TaskEntity objects
      final tasks =
          jsonResponse.map((task) {
            if (task is! Map<String, dynamic>) {
              throw Exception('Invalid task format: Expected JSON object');
            }

            final title = task['title']?.toString();
            final description = task['description']?.toString();
            final dueDateStr = task['dueDate']?.toString();

            if (title == null || title.isEmpty) {
              throw Exception('Missing or invalid title');
            }

            DateTime? dueDate;
            try {
              dueDate = dueDateStr != null ? DateTime.parse(dueDateStr) : null;
              if (dueDate != null && dueDate.isBefore(currentDate)) {
                throw Exception('Due date is in the past: $dueDateStr');
              }
            } catch (e) {
              throw Exception('Invalid due date format: $dueDateStr');
            }

            return TaskEntity(
              id: null,
              title: title,
              description: description,
              dueDate: dueDate,
              isCompleted: false,
              lastSyncTime: currentDate,
              email: userEmail,
            );
          }).toList();

      return tasks;
    } catch (e) {
      rethrow;
    }
  }
}
