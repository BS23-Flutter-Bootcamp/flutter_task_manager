import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Task List',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            color:
                index % 2 == 0
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).cardColor,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(
                'Todo task $index',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  decoration:
                      index % 2 == 0 ? TextDecoration.lineThrough : null,
                  color:
                      index % 2 == 0
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.titleLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Todo task description for task $index',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration:
                      index % 2 == 0 ? TextDecoration.lineThrough : null,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              leading: Checkbox(
                value: index % 2 == 0,
                onChanged: (value) {},
                activeColor: Theme.of(context).primaryColor,
              ),
              onTap: () {
                context.go(RouteNames.editTaskSceen);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouteNames.addTaskScreen);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
