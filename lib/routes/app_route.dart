import 'package:flutter_task_manager/routes/app_route_name.dart';
import 'package:flutter_task_manager/view/add_task_screen.dart';
import 'package:flutter_task_manager/view/edit_task_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_task_manager/view/task_list_screen.dart';
import '../view/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: RouteNames.splashScreen,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.taskListScreen,
      name: 'tasks',
      builder: (context, state) => const TaskListScreen(),
    ),
     GoRoute(
      path: RouteNames.addTaskScreen,
      name: 'add',
      builder: (context, state) => const AddTaskScreen(),
    ),
     GoRoute(
      path: RouteNames.editTaskSceen,
      name: 'edit',
      builder: (context, state) => const EditTaskScreen(),
    ),
  ],
);
