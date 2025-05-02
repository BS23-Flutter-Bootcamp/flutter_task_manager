import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = "1";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
        channelId,
        "thecodexhub",
        channelDescription:
            "This channel is responsible for all the local notifications",
        playSound: true,
        priority: Priority.high,
        importance: Importance.high,
      );

  final NotificationDetails notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
  );

  Future<void> _requestPermissions() async {
    try {
      final notificationStatus = await Permission.notification.request();
      debugPrint('Notification permission status: $notificationStatus');

      if (!notificationStatus.isGranted) {
        debugPrint('Notification permission denied');
        _showPermissionDialog('Notification');
        return;
      }

      final alarmStatus = await Permission.scheduleExactAlarm.request();
      debugPrint('Exact alarm permission status: $alarmStatus');

      if (!alarmStatus.isGranted) {
        _showPermissionDialog('Exact Alarm');
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    }
  }

  Future<void> _showPermissionDialog(String permissionType) async {
    if (navigatorKey.currentContext == null) {
      debugPrint('No context available for dialog');
      return;
    }

    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder:
          (context) => AlertDialog(
            title: Text('$permissionType Permission Required'),
            content: Text(
              'This app needs $permissionType permission to schedule notifications. '
              'Please enable it in settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );

    if (result == true) {
      await openAppSettings();
    }
  }

  Future<void> scheduleImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final scheduledTime = DateTime.now().add(const Duration(seconds: 3));

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<bool> checkPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final alarmStatus = await Permission.scheduleExactAlarm.status;

    return notificationStatus.isGranted && alarmStatus.isGranted;
  }

  // Update init method to check permissions
  Future<void> init() async {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _requestPermissions();
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime eventDate,
    TimeOfDay eventTime,
    String payload, [
    DateTimeComponents? dateTimeComponents,
  ]) async {
    final scheduledTime = eventDate.add(
      Duration(hours: eventTime.hour, minutes: eventTime.minute),
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
      payload: payload,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  Future<bool> canScheduleExactAlarms() async {
    try {
      final status = await Permission.scheduleExactAlarm.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
