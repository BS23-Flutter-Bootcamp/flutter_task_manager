import 'dart:convert';
import 'package:flutter/foundation.dart';
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
      final prompt = '''
Given the following user request: "$userPrompt",Generate a to-do plan based on the request. If no days are specified, 
create 3–5 relevant tasks. If days are provided, distribute tasks accordingly.
  Each task must have:
- A title (short, descriptive, max 50 characters).
- A description (1–2 sentences detailing the task).
- A due date (in ISO 8601 format, e.g., "2025-05-01T14:00:00", within the next 7 days from today, ${currentDate.toIso8601String()}).
Output **only** a JSON array of objects, without any Markdown, code blocks, or additional text. Example:
[
  {
    "title": "Task 1",
    "description": "Description of task 1.",
    "dueDate": "2025-05-01T14:00:00"
  },
  ...
]
Ensure due dates are realistic, spread across the next 7 days, and in local time. If the prompt is vague, make reasonable assumptions to create relevant tasks.
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
