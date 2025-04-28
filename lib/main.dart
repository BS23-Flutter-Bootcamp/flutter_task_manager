import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/firebase_options.dart';
import 'package:flutter_task_manager/model/repositories/notification_repository.dart';
import 'package:flutter_task_manager/model/services/login_service.dart';
import 'package:flutter_task_manager/model/services/notification_service.dart';
import 'package:flutter_task_manager/routing/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_task_manager/viewmodel/login_screen_view_model.dart';
import 'package:flutter_task_manager/viewmodel/notification_view_model.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize the notification service
    NotificationService notificationService = NotificationService();
    await notificationService.init();

    // Check remember me status
    final loginService = LoginService();
    await loginService.init();
    await loginService.checkRememberMeStatus();
  } catch (e) {
    if (kDebugMode) {
      print('Initialization failed: $e');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => TaskListViewModel()..fetchTasks()),
        ChangeNotifierProvider(
          create: (_) => NotificationViewModel(
            NotificationRepository(NotificationService()),
          )..initialize(),
        ),
      ],
      child: const MainApp(),
    ),
  );
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