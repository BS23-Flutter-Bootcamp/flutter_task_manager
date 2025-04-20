import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/task_list_item.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


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
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final tasks = viewModel.tasks;
            return tasks.isEmpty
                ? const Center(child: Text('No tasks available'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskListItem(
                        task: task,
                        onTap: () {
                          context.go(
                            RouteNames.detailsPageScreen,
                            extra: task,
                          );
                        },
                        onCheckboxChanged: (value) {
                          viewModel.toggleTaskCompletion(task);
                        },
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