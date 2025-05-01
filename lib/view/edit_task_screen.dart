import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/view/widgets/toast_snackbar.dart';
import 'package:flutter_task_manager/viewmodel/edit_task_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity? task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => EditTaskViewModel(task: widget.task),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(RouteNames.taskListScreen),
          ),
          title: Text(
            'Edit Task',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.appBarTheme.foregroundColor,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Builder(
          builder: (BuildContext providerContext) {
            final viewModel = Provider.of<EditTaskViewModel>(
              providerContext,
              listen: false,
            );
            return ListenableBuilder(
              listenable: viewModel,
              builder: (context, child) {
                if (viewModel.task == null) {
                  return const Center(child: Text('No task to edit'));
                }
                // Sync controller text with ViewModel state
                if (_titleController.text != viewModel.title) {
                  _titleController.text = viewModel.title;
                }
                if (_descriptionController.text !=
                    (viewModel.description ?? '')) {
                  _descriptionController.text = viewModel.description ?? '';
                }
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
                              'Edit your to-do',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _titleController,
                              onChanged: viewModel.setTitle,
                              decoration: InputDecoration(
                                labelText: 'Title *',
                                labelStyle: TextStyle(color: theme.hintColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _descriptionController,
                              onChanged: viewModel.setDescription,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(color: theme.hintColor),
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
                                  initialDate:
                                      viewModel.dueDate ?? DateTime.now(),
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
                                  labelStyle: TextStyle(color: theme.hintColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                child: Text(
                                  viewModel.dueDate != null
                                      ? '${viewModel.dueDate!.day}/${viewModel.dueDate!.month}/${viewModel.dueDate!.year}'
                                      : 'Select a date',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        viewModel.isLoading ||
                                                viewModel.title.isEmpty
                                            ? null
                                            : () async {
                                              final success =
                                                  await viewModel.updateTask();
                                              if (success && context.mounted) {
                                                ToastSnackbar.show(
                                                  context: context,
                                                  message:
                                                      'Task updated successfully!',
                                                  color: Colors.green[300]!,
                                                );
                                                context.go(
                                                  RouteNames.taskListScreen,
                                                );
                                              } else if (context.mounted) {
                                                ToastSnackbar.show(
                                                  context: context,
                                                  message:
                                                      viewModel.errorMessage ??
                                                      'Failed to update task',
                                                  color: Colors.red[300]!,
                                                );
                                              }
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          viewModel.title.isEmpty
                                              ? theme.primaryColor.withAlpha(
                                                128,
                                              )
                                              : theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
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
                                              'UPDATE TASK',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        viewModel.isLoading
                                            ? null
                                            : () async {
                                              final success =
                                                  await viewModel.deleteTask();
                                              if (success && context.mounted) {
                                                ToastSnackbar.show(
                                                  context: context,
                                                  message:
                                                      'Task deleted successfully!',
                                                  color: Colors.green[300]!,
                                                );
                                                context.go(
                                                  RouteNames.taskListScreen,
                                                );
                                              } else if (context.mounted) {
                                                ToastSnackbar.show(
                                                  context: context,
                                                  message:
                                                      viewModel.errorMessage ??
                                                      'Failed to delete task',
                                                  color: Colors.red,
                                                );
                                              }
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
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
                                              'DELETE TASK',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (viewModel.errorMessage != null)
                              Text(
                                viewModel.errorMessage!,
                                style: theme.textTheme.bodyMedium?.copyWith(
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
