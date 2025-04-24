import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/services/database_service.dart';
import 'package:flutter_task_manager/model/services/firestore_service.dart';

class TaskRepository {
  TaskRepository({
    DatabaseService? databaseService,
    FirestoreService? firestoreService,
  })  : _databaseService = databaseService ?? DatabaseService(),
        _firestoreService = firestoreService ?? FirestoreService();

  final DatabaseService _databaseService;
  final FirestoreService _firestoreService;

  String? get _currentUserEmail => FirebaseAuth.instance.currentUser?.email;

  Future<void> addTask(TaskEntity task) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      final updatedTask = TaskEntity(
        id: task.id ?? DateTime.now().millisecondsSinceEpoch, // Ensure unique ID
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        lastSyncTime: DateTime.now(),
        email: _currentUserEmail!,
      );
      // Save to SQLite first
      final existingTask = await _databaseService.getTaskById(updatedTask.id!);
      if (existingTask == null) {
        await _databaseService.insertTask(updatedTask);
      } else {
        await _databaseService.updateTask(updatedTask);
      }
      // Sync to Firestore
      await _firestoreService.upsertTask(updatedTask, _currentUserEmail!);
    } catch (e) {
      if (kDebugMode) print('Add Task Error: $e');
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasks() async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      return await _databaseService.getTasksByEmail(_currentUserEmail!);
    } catch (e) {
      if (kDebugMode) print('Get Tasks Error: $e');
      rethrow;
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      final updatedTask = TaskEntity(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        lastSyncTime: DateTime.now(),
        email: _currentUserEmail!,
      );
      // Update SQLite first
      await _databaseService.updateTask(updatedTask);
      // Sync to Firestore
      await _firestoreService.upsertTask(updatedTask, _currentUserEmail!);
    } catch (e) {
      if (kDebugMode) print('Update Task Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      // Delete from SQLite first
      await _databaseService.deleteTask(id);
      // Delete from Firestore
      await _firestoreService.deleteTask(id, _currentUserEmail!);
    } catch (e) {
      if (kDebugMode) print('Delete Task Error: $e');
      rethrow;
    }
  }

  Future<void> syncTasks() async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');

      // Get local and remote tasks
      final localTasks = await _databaseService.getTasksByEmail(_currentUserEmail!);
      final remoteTasks = await _firestoreService.getTasks(_currentUserEmail!);

      // Sync local to remote (only newer tasks)
      for (final localTask in localTasks) {
        final remoteTask = remoteTasks.firstWhere(
          (rt) => rt.id == localTask.id,
          orElse: () => TaskEntity(
            id: localTask.id,
            title: '',
            dueDate: null,
            email: _currentUserEmail!,
            lastSyncTime: DateTime(1970),
          ),
        );
        if (remoteTask.lastSyncTime == null ||
            localTask.lastSyncTime!.isAfter(remoteTask.lastSyncTime!)) {
          await _firestoreService.upsertTask(localTask, _currentUserEmail!);
        }
      }

      // Sync remote to local (only newer tasks, avoid deleted tasks)
      for (final remoteTask in remoteTasks) {
        final localTask = localTasks.firstWhere(
          (lt) => lt.id == remoteTask.id,
          orElse: () => TaskEntity(
            id: remoteTask.id,
            title: '',
            dueDate: null,
            email: _currentUserEmail!,
            lastSyncTime: DateTime(1970),
          ),
        );
        if (localTask.lastSyncTime == null ||
            remoteTask.lastSyncTime!.isAfter(localTask.lastSyncTime!)) {
          final existingTask = await _databaseService.getTaskById(remoteTask.id!);
          if (existingTask == null) {
            await _databaseService.insertTask(remoteTask);
          } else {
            await _databaseService.updateTask(remoteTask);
          }
        }
      }

      // Remove local tasks not in remote (handle deletions)
      for (final localTask in localTasks) {
        if (!remoteTasks.any((rt) => rt.id == localTask.id)) {
          await _databaseService.deleteTask(localTask.id!);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Sync Tasks Error: $e');
      rethrow;
    }
  }
}