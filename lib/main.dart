import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/firebase_options.dart';
import 'package:flutter_task_manager/model/services/login_service.dart';
import 'package:flutter_task_manager/model/services/notification_service.dart';
import 'package:flutter_task_manager/routing/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_task_manager/viewmodel/login_screen_view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: _buildThemeData(),
      ),
    );
  }
}

ThemeData _buildThemeData() {
  return ThemeData(
    primaryColor: AppConstants.primaryColor,
    hintColor: AppConstants.hintColor,
    scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppConstants.textColorDark),
      bodyMedium: TextStyle(color: AppConstants.textColorLight),
    ),
    appBarTheme: AppBarTheme(color: AppConstants.textColorDark),
  );
}
