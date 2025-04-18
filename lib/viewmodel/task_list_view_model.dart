
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/repositories/task_repository.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';

class TaskListViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  List<TaskEntity> _tasks = [];

  List<TaskEntity> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await _taskRepository.getTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    final updatedTask = TaskEntity(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: !task.isCompleted,
    );
    await _taskRepository.updateTask(updatedTask);
    await fetchTasks();
  }

  Future<void> deleteTask(int id) async {
    await _taskRepository.deleteTask(id);
    await fetchTasks();
  }
}