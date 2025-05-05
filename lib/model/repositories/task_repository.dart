import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/services/database_service.dart';
import 'package:flutter_task_manager/model/services/firestore_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_task_manager/model/repositories/notification_repository.dart';
import 'package:intl/intl.dart';

class TaskRepository {
  TaskRepository({
    DatabaseService? databaseService,
    FirestoreService? firestoreService,
    NotificationRepository? notificationRepository,
  }) : _databaseService = databaseService ?? DatabaseService(),
       _firestoreService = firestoreService ?? FirestoreService(),
       _notificationRepository =
           notificationRepository ?? NotificationRepository();

  final DatabaseService _databaseService;
  final FirestoreService _firestoreService;
  final NotificationRepository _notificationRepository;

  String? get _currentUserEmail => FirebaseAuth.instance.currentUser?.email;

  Future<int> addTask(TaskEntity task) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      final updatedTask = TaskEntity(
        id: null,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        isCompleted: task.isCompleted,
        lastSyncTime: DateTime.now(),
        email: _currentUserEmail!,
        isDeleted: false,
      );
      final taskId = await _databaseService.insertTask(updatedTask);
      final taskWithId = TaskEntity(
        id: taskId,
        title: updatedTask.title,
        description: updatedTask.description,
        dueDate: updatedTask.dueDate,
        isCompleted: updatedTask.isCompleted,
        lastSyncTime: updatedTask.lastSyncTime,
        email: updatedTask.email,
        isDeleted: false,
      );
      await _notificationRepository.scheduleImmediateNotification(
        id: taskId,
        title: '📅 Task Scheduled!',
        body:
            'Task "${task.title}" is set for ${task.dueDate != null ? DateFormat('EEE, MMM d, yyyy - hh:mm a').format(task.dueDate!) : 'unknown date'}.  Stay focused and get things done!',
      );

      await _notificationRepository.scheduleTaskNotifications(taskWithId);
      if (await _isOnline()) {
        await _firestoreService.upsertTask(taskWithId, _currentUserEmail!);
      }
      return taskId;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskEntity>> getTasks() async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      return await _databaseService.getTasksByEmail(_currentUserEmail!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      if (task.id == null) throw Exception('Task ID is null');
      if (await _isOnline()) {
        final remoteTask = await _firestoreService.getTask(
          task.id!,
          _currentUserEmail!,
        );
        if (remoteTask != null &&
            remoteTask.isDeleted &&
            remoteTask.lastSyncTime!.isAfter(
              task.lastSyncTime ?? DateTime(1970),
            )) {
          await _databaseService.deleteTask(task.id!);
          await _notificationRepository.cancelNotification(task.id!);
          return;
        }
      }
      final updatedTask = task.copyWith(
        lastSyncTime: DateTime.now(),
        email: _currentUserEmail!,
      );
      await _notificationRepository.cancelNotification(task.id!);
      await _notificationRepository.scheduleImmediateNotification(
        id: task.id!,
        title: '✅ Task Updated!',
        body:
            'Your task has been successfully updated. Stay on track and keep up the momentum!',
      );
      await _notificationRepository.scheduleTaskNotifications(updatedTask);
      await _databaseService.updateTask(updatedTask);
      if (await _isOnline()) {
        await _firestoreService.upsertTask(updatedTask, _currentUserEmail!);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      final task = await _databaseService.getTaskById(id);
      if (task != null) {
        final updatedTask = task.copyWith(
          isDeleted: true,
          lastSyncTime: DateTime.now(),
        );
        await _databaseService.updateTask(updatedTask);
        await _notificationRepository.cancelNotification(id);
        if (await _isOnline()) {
          await _firestoreService.upsertTask(updatedTask, _currentUserEmail!);
          await syncTasks();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncTasks() async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      if (!await _isOnline()) {
        return;
      }

      final localTasks = await _databaseService.getTasks();
      final remoteTasks = await _firestoreService.getTasks(_currentUserEmail!);

      // Sync local to remote
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
                isDeleted: false,
              ),
        );
        if (localTask.lastSyncTime!.isAfter(
          remoteTask.lastSyncTime ?? DateTime(1970),
        )) {
          await _firestoreService
              .upsertTask(localTask, _currentUserEmail!)
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () => throw Exception('Firestore sync timed out'),
              );
        }
      }

      // Sync remote to local
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
                isDeleted: false,
              ),
        );
        if (remoteTask.lastSyncTime!.isAfter(
          localTask.lastSyncTime ?? DateTime(1970),
        )) {
          if (remoteTask.isDeleted) {
            await _databaseService.deleteTask(remoteTask.id!);
            await _notificationRepository.cancelNotification(
              remoteTask.id!,
            );
          } else {
            final existingTask = await _databaseService.getTaskById(
              remoteTask.id!,
            );
            if (existingTask == null) {
              await _databaseService.insertTask(remoteTask);
              if (!remoteTask.isCompleted) {
                await _notificationRepository.scheduleTaskNotifications(
                  remoteTask,
                );
              }
            } else {
              await _databaseService.updateTask(remoteTask);
              await _notificationRepository.cancelNotification(
                remoteTask.id!,
              );
              if (!remoteTask.isCompleted) {
                await _notificationRepository.scheduleTaskNotifications(
                  remoteTask,
                );
              }
            }
          }
        }
      }

      await _databaseService.deleteTasksWhere(isDeleted: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<int>> addTasksFromAI(List<TaskEntity> tasks) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      final taskIds = <int>[];
      for (var task in tasks) {
        final taskId = await addTask(task);
        taskIds.add(taskId);
      }
      return taskIds;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
