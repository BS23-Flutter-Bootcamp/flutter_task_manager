import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/repositories/notification_repository.dart';
import 'package:flutter_task_manager/model/services/notification_service.dart';
import 'package:flutter_task_manager/viewmodel/notification_view_model.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskListViewModel()..fetchTasks(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationViewModel(
            NotificationRepository(NotificationService()),
          )..initialize(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
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
                  icon: const Icon(Icons.sync, color: Colors.white),
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
        body: Consumer<TaskListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final tasks = viewModel.tasks;
            return tasks.isEmpty
                ? const Center(child: Text('No tasks available'))
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Consumer<NotificationViewModel>(
                            builder: (context, notificationViewModel, _) {
                              return IconButton(
                                icon: const Icon(Icons.add_alert, color: Colors.blue),
                                onPressed: () async {
                                  try {
                                    await notificationViewModel.showSampleNotification();
                            
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to send notification: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
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