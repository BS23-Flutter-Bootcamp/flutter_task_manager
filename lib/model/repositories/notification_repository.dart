import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService _notificationService;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationRepository([NotificationService? notificationService])
    : _notificationService = notificationService ?? NotificationService();

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    await _notificationService.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime eventDate,
    required TimeOfDay eventTime,
    Map<String, dynamic>? payload,
    DateTimeComponents? dateTimeComponents,
  }) async {
    await _notificationService.scheduleNotification(
      id,
      title,
      body,
      eventDate,
      eventTime,
      payload != null ? jsonEncode(payload) : '',
      dateTimeComponents,
    );
  }

  //Schedule test notification
  Future<void> scheduleImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notificationService.scheduleImmediateNotification(
      id: id,
      title: title,
      body: body,
    );
  }

  /// Schedule a periodic notification
  Future<void> scheduleTaskNotifications(TaskEntity task) async {
    if (task.dueDate == null || task.isCompleted) {
      return;
    }

    try {
      final scheduledMinutes = task.dueDate!.subtract(Duration(minutes: 15));
      final canUseExact = await _notificationService.canScheduleExactAlarms();

      if (scheduledMinutes.isAfter(DateTime.now())) {
        await scheduleNotification(
          id: task.id!,
          title: '⏳ Upcoming Task!',
          body:
              '🚀 Stay on track! Your task "${task.title}" is due in 15 minutes. Time to get things done!',
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
      rethrow;
    }
  }

  Future<void> cancelTaskNotifications(int taskId) async {
    try {
      await notificationsPlugin.cancel(taskId);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  /// Initialize the notification service
  Future<void> initNotification() async {
    await _notificationService.init();
  }
}
