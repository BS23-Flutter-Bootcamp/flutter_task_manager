import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/model/services/database_service.dart';
import 'package:flutter_task_manager/model/services/firestore_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_task_manager/model/repositories/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskRepository {
  TaskRepository({
    DatabaseService? databaseService,
    FirestoreService? firestoreService,
    NotificationRepository? notificationRepository,
  })  : _databaseService = databaseService ?? DatabaseService(),
        _firestoreService = firestoreService ?? FirestoreService(),
        _notificationRepository = notificationRepository ?? NotificationRepository();

  final DatabaseService _databaseService;
  final FirestoreService _firestoreService;
  final NotificationRepository _notificationRepository;
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  String? get _currentUserEmail => FirebaseAuth.instance.currentUser?.email;

  Future<bool> _canScheduleExactAlarms() async {
    try {
      final status = await Permission.scheduleExactAlarm.status;
      if (kDebugMode) {
        print('Schedule exact alarm permission: $status');
      }
      return status.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking exact alarm permission: $e');
      }
      return false;
    }
  }

  Future<void> _scheduleTaskNotifications(TaskEntity task) async {
    if (task.dueDate == null || task.isCompleted) {
      if (kDebugMode && task.isCompleted) {
        if (kDebugMode) {
          print('Skipping notifications for completed task: ${task.id}');
        }
      }
      return;
    }

    try {
      final scheduledMinutes = task.dueDate!.subtract(Duration(minutes: 59));
      // Check exact alarm permission
      final canUseExact = await _canScheduleExactAlarms();

      // Schedule 59-minute reminder
      if (scheduledMinutes.isAfter(DateTime.now())) {
        if (kDebugMode) {
          print('Scheduling 59-min reminder for task ${task.id} at $scheduledMinutes');
        }
        await _notificationRepository.scheduleNotification(
          id: task.id!,
          title: 'Task Reminder',
          body: 'Task "${task.title}" is due in 59 minutes!',
          eventDate: DateTime(
            scheduledMinutes.year,
            scheduledMinutes.month,
            scheduledMinutes.day,
          ),
          eventTime: TimeOfDay(
            hour: scheduledMinutes.hour,
            minute: scheduledMinutes.minute,
          ),
          payload: {'taskId': task.id},
          dateTimeComponents: canUseExact ? null : DateTimeComponents.time,
        );
      }

     
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule notifications for task ${task.id}: $e');
      }
      // Continue task operation despite notification failure
    }
  }

  Future<void> _cancelTaskNotifications(int taskId) async {
    if (kDebugMode) {
      print('Canceling notifications for task: $taskId');
    }
    try {
      await notificationsPlugin.cancel(taskId);
     
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cancel notifications for task $taskId: $e');
      }
    }
  }

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
      );
      // Schedule test notification
      
      await _notificationRepository.scheduleTestNotification(
        id: taskId,
        title: 'Task Reminder',
        body: 'Task "${task.title}" is due in 59 minutes!',
      );

      // Schedule notifications for incomplete tasks
      await _scheduleTaskNotifications(taskWithId);
      // Sync to Firestore if online
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _firestoreService
            .upsertTask(taskWithId, _currentUserEmail!)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          throw Exception('Firestore sync timed out');
        });
      }
      return taskId;
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
      // Cancel existing notifications
      if (task.id != null) {
        await _cancelTaskNotifications(task.id!);
      }
      // Schedule new notifications if task is incomplete
       await _notificationRepository.scheduleTestNotification(
        id: task.id!,
        title: 'Task Reminder',
        body: 'Task "${task.title}" is due in 59 minutes!',
      );
      await _scheduleTaskNotifications(updatedTask);
      // Update SQLite
      await _databaseService.updateTask(updatedTask);
      // Sync to Firestore if online
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _firestoreService
            .upsertTask(updatedTask, _currentUserEmail!)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          throw Exception('Firestore sync timed out');
        });
      }
    } catch (e) {
      if (kDebugMode) print('Update Task Error: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');
      // Cancel notifications
      await _cancelTaskNotifications(id);
      // Delete from SQLite
      await _databaseService.deleteTask(id);
      // Delete from Firestore if online
      final connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.none)) {
        await _firestoreService
            .deleteTask(id, _currentUserEmail!)
            .timeout(const Duration(seconds: 10), onTimeout: () {
          throw Exception('Firestore delete timed out');
        });
      }
    } catch (e) {
      if (kDebugMode) print('Delete Task Error: $e');
      rethrow;
    }
  }

  Future<void> syncTasks() async {
    try {
      if (_currentUserEmail == null) throw Exception('User not authenticated');

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (kDebugMode) print('Offline mode: Skipping Firestore sync');
        return;
      }

      final localTasks = await _databaseService.getTasksByEmail(_currentUserEmail!);
      final remoteTasks = await _firestoreService
          .getTasks(_currentUserEmail!)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Firestore fetch timed out');
      });

      // Sync local to remote
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
        if (localTask.lastSyncTime!.isAfter(remoteTask.lastSyncTime ?? DateTime(1970))) {
          await _firestoreService
              .upsertTask(localTask, _currentUserEmail!)
              .timeout(const Duration(seconds: 10), onTimeout: () {
            throw Exception('Firestore sync timed out');
          });
        }
      }

      // Sync remote to local
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
        if (remoteTask.lastSyncTime!.isAfter(localTask.lastSyncTime ?? DateTime(1970))) {
          final existingTask = await _databaseService.getTaskById(remoteTask.id!);
          if (existingTask == null) {
            await _databaseService.insertTask(remoteTask);
            if (!remoteTask.isCompleted) {
              await _scheduleTaskNotifications(remoteTask);
            }
          } else {
            await _databaseService.updateTask(remoteTask);
            await _cancelTaskNotifications(remoteTask.id!);
            if (!remoteTask.isCompleted) {
              await _scheduleTaskNotifications(remoteTask);
            }
          }
        }
      }

      // Delete remote tasks not in local
      for (final remoteTask in remoteTasks) {
        if (!localTasks.any((lt) => lt.id == remoteTask.id)) {
          await _firestoreService
              .deleteTask(remoteTask.id!, _currentUserEmail!)
              .timeout(const Duration(seconds: 10), onTimeout: () {
            throw Exception('Firestore delete timed out');
          });
        }
      }
    } catch (e) {
      if (kDebugMode) print('Sync Tasks Error: $e');
      rethrow;
    }
  }
}