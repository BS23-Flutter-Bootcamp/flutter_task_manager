import 'package:flutter_task_manager/model/task.dart';

import '../services/database_service.dart';

class TaskRepository {
  final DatabaseService _databaseService = DatabaseService();

  Future<void> addTask(Task task) async {
    await _databaseService.insertTask(task);
  }

  Future<List<Task>> getTasks() async {
    return await _databaseService.getTasks();
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
  }
}