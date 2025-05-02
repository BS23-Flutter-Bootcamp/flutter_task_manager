import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:go_router/go_router.dart';

class HomeBottomNavigationBar {
  static final routes = [RouteNames.addTaskScreen, RouteNames.generateTaskPlan];
  static Widget getBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: Colors.deepPurple[300],

      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 28),
          label: 'Add Task',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome, size: 28),
          label: 'Generate Plan',
        ),
      ],
      onTap: (index) {
        context.go(routes[index]);
      },
    );
  }
}
