import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routes/app_route_name.dart';
import 'package:flutter_task_manager/view/task_list_screen.dart';
import '../view/splash_screen.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteNames.taskListScreen:
        return MaterialPageRoute(builder: (context) => TaskListScreen());
      default:
        return MaterialPageRoute(builder: (context) => SplashScreen());
    }
  }
}
