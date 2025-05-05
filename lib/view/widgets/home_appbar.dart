import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/toast_snackbar.dart';
import 'package:flutter_task_manager/viewmodel/login_view_model.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeAppBar {
  static AppBar getAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 191, 173, 227), // Deeper lavender
              Color.fromARGB(255, 164, 145, 197), // Bold violet for contrast
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () async {
          final loginViewModel = Provider.of<LoginViewModel>(
            context,
            listen: false,
          );
          await loginViewModel.logout();
          if (context.mounted) {
            context.go(RouteNames.loginScreen);
          }
        },
      ),
      centerTitle: true,
      title: Text(
        'Task List',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
                final connectivityResult =
                    await Connectivity().checkConnectivity();
                if (connectivityResult.contains(ConnectivityResult.none)) {
                  if (context.mounted) {
                    ToastSnackbar.show(
                      context: context,
                      message: 'Offline mode: Sync unavailable',
                      color: Colors.orange[300]!,
                    );
                  }
                  return;
                }
                try {
                  await viewModel.fetchTasks(sync: true);
                  if (context.mounted) {
                    ToastSnackbar.show(
                     context:  context,
                     message:  'Tasks synced successfully!',
                      color: Colors.green[300]!,
                    );
                   
                  }
                } catch (e) {
                  if (context.mounted) {
                    ToastSnackbar.show(
                      context: context,
                      message: 'Sync failed. Please try again.',
                      color: Colors.red[300]!,
                    );
                  }
                }
              },
            );
          },
        ),
      ],
    );
  }
}
