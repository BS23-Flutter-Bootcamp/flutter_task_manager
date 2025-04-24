import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/task_list_item.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskListViewModel()..fetchTasks(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Handle logout action here
              // For example, you can navigate to the login screen or perform logout logic
              context.go(RouteNames.loginScreen);
              
            },
          ),

          centerTitle: true,
          title: Text(
            'Task List',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
          actions: [
            Builder(
              builder: (BuildContext providerContext) {
                return IconButton(
                  tooltip: 'Sync Tasks',
                  iconSize: 30,
                  icon: const Icon(Icons.sync,color: Colors.white,),
                  onPressed: () async {
                    final viewModel = Provider.of<TaskListViewModel>(
                      providerContext,
                      listen: false,
                    );
                    // Check connectivity
                    final connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult.contains(ConnectivityResult.none)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Offline mode: Sync unavailable'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                      return;
                    }
                    try {
                      await viewModel.fetchTasks(sync: true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tasks synced successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Sync failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
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
                                  RouteNames.editTaskScreen,
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
