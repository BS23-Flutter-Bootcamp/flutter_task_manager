import 'package:flutter_task_manager/model/entities/task_entity.dart';

import '../services/database_service.dart';

class TaskRepository {
  TaskRepository({DatabaseService? databaseService})
    : _databaseService = databaseService ?? DatabaseService();

  final DatabaseService _databaseService;

  Future<void> addTask(TaskEntity task) async {
    await _databaseService.insertTask(task);
  }

  Future<List<TaskEntity>> getTasks() async {
    return await _databaseService.getTasks();
  }

  Future<void> updateTask(TaskEntity task) async {
    await _databaseService.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _databaseService.deleteTask(id);
  }
}
