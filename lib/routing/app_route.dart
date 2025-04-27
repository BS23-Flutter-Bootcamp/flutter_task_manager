import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/add_task_screen.dart';
import 'package:flutter_task_manager/view/ai_screen.dart';
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
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.taskListScreen,
      builder: (context, state) => const TaskListScreen(),
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return RouteNames.loginScreen;
        }
        return null;
      },
    ),
    GoRoute(
      path: RouteNames.addTaskScreen,
      builder: (context, state) => const AddTaskScreen(),
    ),
   GoRoute(
      path: RouteNames.editTaskScreen,
      builder: (context, state) => EditTaskScreen(task: state.extra as TaskEntity?),
    ),
    GoRoute(
      path: RouteNames.detailsPageScreen,
      builder: (context, state) => const DetailsPageScreen(),
    ),
    GoRoute(
      path: RouteNames.signUpScreen,
      builder: (context, state) => SignUpScreenView(), // Added Sign Up route
    ),
    GoRoute(
      path: RouteNames.loginScreen,
      builder: (context, state) => LoginScreenView(), // Added Sign Up route
    ),
     GoRoute(
      path: RouteNames.generateTaskPlan,
      builder: (context, state) => AiScreen(),
    ),
    
  ],
);
