import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route.dart';

void main() {
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
        primaryColor: Colors.deepPurple[300],
        hintColor: Colors.amber,
        scaffoldBackgroundColor: Colors.deepPurple[50],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.deepPurple[600]),
          bodyMedium: TextStyle(color: Colors.deepPurple[400]),
        ),
        appBarTheme: AppBarTheme(color: Colors.deepPurple[400]),
      ),
    );
  }
}
