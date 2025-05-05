import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_task_manager/config/firebase_options.dart';
import 'package:flutter_task_manager/model/repositories/login_repository.dart';
import 'package:flutter_task_manager/model/repositories/notification_repository.dart';


class AppInitializer {
  static Future<void> initialize() async {
    try {
      await dotenv.load();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await NotificationRepository().initNotification();
      await LoginRepository().isRegistered();

    } catch (e) {
      rethrow;
    }
  }
}
