import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _notificationRepository;

  NotificationViewModel(this._notificationRepository);

  Future<void> initialize() async {
    await _notificationRepository.initNotification();
    notifyListeners();
  }

  Future<void> showSampleNotification() async {
    try {
      await _notificationRepository.showNotification(
        title: 'Sample Notification',
        body: 'This is a test notification.',
        id: 1,
      );
      notifyListeners();
      debugPrint('Notification shown successfully');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
