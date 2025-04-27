import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/notification_service.dart';

class NotificationRepository {
  final NotificationService _notificationService;

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
  Future<void> scheduleTestNotification({
    required int id,
    required String title,
    required String body
  }) async {
    await _notificationService.scheduleTestNotification(
      id: id,
      title: title,
      body: body,
    );
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