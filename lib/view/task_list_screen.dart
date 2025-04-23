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
          actions: [
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: () async {
                final viewModel = Provider.of<TaskListViewModel>(
                  context,
                  listen: false,
                );
                try {
                  await viewModel.fetchTasks();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tasks synced successfully!'),
                        backgroundColor:
                            Colors.green, // Adjust color based on SnackbarType
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sync failed: $e',
                          style: const TextStyle(
                            color: Colors.white,
                          ), // Ensures contrast
                        ),
                        backgroundColor: Colors.red, // Error indication
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: Builder(
          builder: (BuildContext providerContext) {
            return ListenableBuilder(
              listenable: Provider.of<TaskListViewModel>(
                providerContext,
                listen: false,
              ),
              builder: (context, child) {
                final viewModel = Provider.of<TaskListViewModel>(
                  providerContext,
                );
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tasks = viewModel.tasks;
                return tasks.isEmpty
                    ? const Center(child: Text('No tasks available'))
                    : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
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
                          }, childCount: tasks.length),
                        ),
                      ],
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
