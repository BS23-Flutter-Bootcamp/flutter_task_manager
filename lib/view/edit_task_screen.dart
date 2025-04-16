import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routes/app_route_name.dart';
import 'package:go_router/go_router.dart';

class EditTaskScreen extends StatelessWidget {
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.taskListScreen);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text('Edit task page')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouteNames.editTaskSceen);
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
