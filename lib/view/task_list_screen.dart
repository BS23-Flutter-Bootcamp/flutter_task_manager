import 'package:flutter/material.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../routing/app_route_name.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskListViewModel()..fetchTasks(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Task List',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        body: Consumer<TaskListViewModel>(
          builder: (context, viewModel, child) {
            final tasks = viewModel.tasks;
            return tasks.isEmpty
                ? const Center(child: Text('No tasks available'))
                : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      color:
                          task.isCompleted
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).cardColor,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
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
                          context.go(RouteNames.editTaskScreen, extra: task);
                        },
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            viewModel.toggleTaskCompletion(task);
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                decoration:
                                    task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    task.isCompleted
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description ?? 'No description',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                decoration:
                                    task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Due Date: ${task.dueDate != null ? DateFormat.yMMMd().format(task.dueDate!) : 'No due date'}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }
}
