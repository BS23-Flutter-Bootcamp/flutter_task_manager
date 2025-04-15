import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routes/app_route.dart';
import 'package:flutter_task_manager/routes/app_route_name.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splashScreen,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}