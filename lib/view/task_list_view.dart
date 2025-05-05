import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/home_appbar.dart';
import 'package:flutter_task_manager/view/widgets/home_bottom_navigation_bar.dart';
import 'package:flutter_task_manager/view/widgets/task_action_handler.dart';
import 'package:flutter_task_manager/view/widgets/task_list_item.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskListViewModel()..fetchTasks(),
      child: Scaffold(
        appBar: HomeAppBar.getAppBar(context),
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
                    return Dismissible(
                      key: Key(task.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        await TaskActionHandler.deleteTask(
                          context: context,
                          viewModel: viewModel,
                          task: task,
                        );
                        return false;
                      },
                      child: TaskListItem(
                        task: task,
                        onTap: () {
                          context.go(RouteNames.detailsPageScreen, extra: task);
                        },
                        onCheckboxChanged:
                            (value) => viewModel.toggleTaskCompletion(task),
                      ),
                    );
                  },
                );
          },
        ),
        bottomNavigationBar: HomeBottomNavigationBar.getBottomNavBar(context),
      ),
    );
  }
}
