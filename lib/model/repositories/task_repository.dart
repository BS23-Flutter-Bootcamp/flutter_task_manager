import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/services/database_service.dart';
import 'package:flutter_task_manager/model/services/firestore_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TaskRepository {
  TaskRepository({
    DatabaseService? databaseService,
    FirestoreService? firestoreService,
  }) : _databaseService = databaseService ?? DatabaseService(),
       _firestoreService = firestoreService ?? FirestoreService();

  final DatabaseService _databaseService;
  final FirestoreService _firestoreService;

  String? get _currentUserEmail => FirebaseAuth.instance.currentUser?.email;

  Future<void> addTask(TaskEntity task) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');

      // Insert the task into the local database and get the auto-generated id
      final db = DatabaseService();
      final int id = await db.insertTask(task);
  
      // Create a new TaskEntity with the generated id
      final taskWithId = TaskEntity(
        id: id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        lastSyncTime: DateTime.now(),
        email: _currentUserEmail!,
      );

          if (kDebugMode) {
        print(id);
        print(taskWithId.toMap());
      }

      // Sync to Firestore if online
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _firestoreService.upsertTask(taskWithId, _currentUserEmail!);
      }
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
      // Sync to Firestore if online
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _firestoreService
            .upsertTask(updatedTask, _currentUserEmail!)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw Exception('Firestore sync timed out');
              },
            );
      }
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
      // Delete from Firestore if online
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _firestoreService
            .deleteTask(id, _currentUserEmail!)
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw Exception('Firestore delete timed out');
              },
            );
      }
    } catch (e) {
      if (kDebugMode) print('Delete Task Error: $e');
      rethrow;
    }
  }

  Future<void> syncTasks() async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');

      // Skip sync if offline
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (kDebugMode) print('Offline mode: Skipping Firestore sync');
        return;
      }

      // Get local and remote tasks
      final localTasks = await _databaseService.getTasksByEmail(
        _currentUserEmail!,
      );
      final remoteTasks = await _firestoreService
          .getTasks(_currentUserEmail!)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Firestore fetch timed out');
            },
          );

      // Sync local to remote (add/update newer tasks)
      for (final localTask in localTasks) {
        final remoteTask = remoteTasks.firstWhere(
          (rt) => rt.id == localTask.id,
          orElse:
              () => TaskEntity(
                id: localTask.id,
                title: '',
                dueDate: null,
                email: _currentUserEmail!,
                lastSyncTime: DateTime(1970),
              ),
        );
        // Prioritize local task if its lastSyncTime is newer
        if (localTask.lastSyncTime!.isAfter(
          remoteTask.lastSyncTime ?? DateTime(1970),
        )) {
          await _firestoreService
              .upsertTask(localTask, _currentUserEmail!)
              .timeout(
                const Duration(seconds: 10),
                onTimeout: () {
                  throw Exception('Firestore sync timed out');
                },
              );
        }
      }

      // Sync remote to local (only for newer remote tasks)
      for (final remoteTask in remoteTasks) {
        final localTask = localTasks.firstWhere(
          (lt) => lt.id == remoteTask.id,
          orElse:
              () => TaskEntity(
                id: remoteTask.id,
                title: '',
                dueDate: null,
                email: _currentUserEmail!,
                lastSyncTime: DateTime(1970),
              ),
        );
        // Only update local if remote is newer
        if (remoteTask.lastSyncTime!.isAfter(
          localTask.lastSyncTime ?? DateTime(1970),
        )) {
          final existingTask = await _databaseService.getTaskById(
            remoteTask.id!,
          );
          if (existingTask == null) {
            await _databaseService.insertTask(remoteTask);
          } else {
            await _databaseService.updateTask(remoteTask);
          }
        }
      }

      // Delete remote tasks not in local (propagate offline deletions)
      for (final remoteTask in remoteTasks) {
        if (!localTasks.any((lt) => lt.id == remoteTask.id)) {
          await _firestoreService
              .deleteTask(remoteTask.id!, _currentUserEmail!)
              .timeout(
                const Duration(seconds: 10),
                onTimeout: () {
                  throw Exception('Firestore delete timed out');
                },
              );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Sync Tasks Error: $e');
      rethrow;
    }
  }
}
