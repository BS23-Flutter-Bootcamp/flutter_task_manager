import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/add_task_screen.dart';
import 'package:flutter_task_manager/view/details_page_screen.dart';
import 'package:flutter_task_manager/view/edit_task_screen.dart';
import 'package:flutter_task_manager/view/login_screen_view.dart';
import 'package:flutter_task_manager/view/sign_up_screen_view.dart';
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
      path: RouteNames.editTaskScreen,
      name: 'edit',
      builder: (context, state) => const EditTaskScreen(),
    ),
    GoRoute(
      path: RouteNames.detailsPageScreen,
      name: 'details',
      builder: (context, state) => const DetailsPageScreen(),
    ),
    GoRoute(
      path: RouteNames.signUpScreen,
      name: 'signup',
      builder: (context, state) => SignUpScreenView(), // Added Sign Up route
    ),
    GoRoute(
      path: RouteNames.loginScreen,
      name: 'login',
      builder: (context, state) => LoginScreenView(), // Added Sign Up route
    ),
  ],
);
