import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_task_manager/config/firebase_options.dart';
import 'package:flutter_task_manager/model/services/login_service.dart';
import 'package:flutter_task_manager/model/services/notification_service.dart';

class AppInitializer {
  static Future<void> initialize() async {
    try {
      await dotenv.load();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await NotificationService().init();

      LoginService()
        ..init()
        ..checkRememberMeStatus();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Initialization failed: $e\n$stackTrace');
      }
    }
  }
}
