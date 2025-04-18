import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route.dart';


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
        primaryColor: Colors.deepPurple[200],
        hintColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.deepPurple[50],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.deepPurple[400]),
          bodyMedium: TextStyle(color: Colors.deepPurple[200]),
        ),
        appBarTheme: AppBarTheme(color: Colors.deepPurple[400]),
      ),
    );
  }
}
