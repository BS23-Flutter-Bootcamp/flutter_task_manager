import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/date_picker_helper.dart';
import 'package:flutter_task_manager/view/widgets/task_form.dart';
import 'package:flutter_task_manager/viewmodel/edit_task_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  EditTaskScreenState createState() => EditTaskScreenState();
}

class EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dueDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dueDateController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = GoRouterState.of(context).extra as TaskEntity;

    return ChangeNotifierProvider(
      create: (_) => EditTaskViewModel(task),
      child: Builder(
        builder: (context) {
          final viewModel = Provider.of<EditTaskViewModel>(
            context,
            listen: false,
          );

          // Initialize controllers once
          if (_titleController.text.isEmpty) {
            _titleController.text = task.title;
            _descriptionController.text = task.description ?? '';
            _dueDateController.text =
                task.dueDate?.toLocal().toString().split(' ')[0] ??
                'YYYY-MM-DD';
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Task'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(RouteNames.taskListScreen),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                       TaskForm(
                          titleController: _titleController,
                          descriptionController: _descriptionController,
                          selectedDate: viewModel.task?.dueDate,
                          errorMessage: viewModel.errorMessage,
                          onDateTap: () async {
                            final pickedDate =
                                await DatePickerHelper.showDatePickerDialog(
                              context: context,
                              initialDate:
                                  viewModel.task?.dueDate ?? DateTime.now(),
                            );
                            if (pickedDate != null) {
                              viewModel.setSelectedDate(pickedDate);
                            
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await viewModel.updateTask(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                dueDate: viewModel.task?.dueDate,
                              );
                              if (success && context.mounted) {
                                context.go(RouteNames.taskListScreen);
                              }
                            }
                          },
                          child: const Text('Update Task'),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () async {
                            final success = await viewModel.deleteTask();
                            if (success && context.mounted) {
                              context.go(RouteNames.taskListScreen);
                            }
                          },
                          child: const Text('Delete Task'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
