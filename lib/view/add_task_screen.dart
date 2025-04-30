import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/toast_snackbar.dart';
import 'package:flutter_task_manager/viewmodel/add_task_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTaskViewModel(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(RouteNames.taskListScreen),
          ),
          title: Text(
            'Add Task',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Builder(
          builder: (BuildContext providerContext) {
            final viewModel = Provider.of<AddTaskViewModel>(
              providerContext,
              listen: false,
            );
            return ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'New Task',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: viewModel.setTitle,
                              decoration: InputDecoration(
                                labelText: 'Title *',
                                labelStyle: TextStyle(color: Theme.of(context).hintColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              onChanged: viewModel.setDescription,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(color: Theme.of(context).hintColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (selectedDate != null) {
                                  viewModel.setDueDate(selectedDate);
                                }
                              },
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Due Date',
                                  labelStyle: TextStyle(color: Theme.of(context).hintColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                child: Text(
                                  '${viewModel.dueDate.day}/${viewModel.dueDate.month}/${viewModel.dueDate.year}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed:
                                  viewModel.isLoading || viewModel.title.isEmpty
                                      ? null
                                      : () async {
                                        final success =
                                            await viewModel.addTask();
                                        if (success && context.mounted) {
                                          ToastSnackbar.show(
                                            context: context,
                                            message: 'Task added successfully',
                                            color: Colors.green[200]!,
                                          );
                                          context.go(RouteNames.taskListScreen);
                                        } else if (context.mounted) {
                                          ToastSnackbar.show(
                                            context: context,
                                            message:
                                                viewModel.errorMessage ??
                                                'Failed to add task',
                                            color: Colors.red[300]!,
                                          );
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    viewModel.title.isEmpty
                                        ? Theme.of(context).primaryColor.withAlpha(128)
                                        : Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                              ),
                              child:
                                  viewModel.isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : Text(
                                        'ADD TASK',
                                        style: Theme.of(context).textTheme.bodyMedium
                                            ?.copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                      ),
                            ),
                            const SizedBox(height: 16),
                            if (viewModel.errorMessage != null)
                              Text(
                                viewModel.errorMessage!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
