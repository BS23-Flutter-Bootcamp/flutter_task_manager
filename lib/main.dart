import 'package:flutter/material.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/routes/app_route.dart';


Future<void> main() async {
  runApp(const MainApp());
}

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
