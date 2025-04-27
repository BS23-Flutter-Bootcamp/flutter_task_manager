import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/firebase_options.dart';
import 'package:flutter_task_manager/model/services/notification_service.dart';
import 'package:flutter_task_manager/routing/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
  
    NotificationService notificationService = NotificationService();
    await notificationService.init();
  } catch (e) {
    if (kDebugMode) {
      print('Initialization failed: $e');
    }
  }
  runApp(const MainApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        hintColor: AppConstants.hintColor,
        scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppConstants.textColorDark),
          bodyMedium: TextStyle(color: AppConstants.textColorLight),
        ),
        appBarTheme: AppBarTheme(color: AppConstants.textColorDark),
      ),
    );
  }
}
