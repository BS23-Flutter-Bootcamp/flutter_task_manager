import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routes/app_route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              onTap: () {
                context.go(RouteNames.editTaskSceen);
              },
              leading: Checkbox(
                value: index % 2 == 0,
                onChanged: (value) {},
                activeColor: Theme.of(context).primaryColor,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Todo task $index',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration:
                          index % 2 == 0 ? TextDecoration.lineThrough : null,
                      color:
                          index % 2 == 0
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Todo task description for task $index',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration:
                          index % 2 == 0 ? TextDecoration.lineThrough : null,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Due Date: ${DateFormat.yMMMd().format(DateTime.now())}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouteNames.addTaskScreen);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
      ),
    );
  }
}
