import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/date_picker_helper.dart';
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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isInitialized = false; 

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = GoRouterState.of(context).extra as TaskEntity?;

    return ChangeNotifierProvider(
      create: (_) => EditTaskViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Task'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RouteNames.taskListScreen);
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Builder(
              builder: (BuildContext providerContext) {
                return ListenableBuilder(
                  listenable: Provider.of<EditTaskViewModel>(providerContext, listen: false),
                  builder: (context, child) {
                    final viewModel = Provider.of<EditTaskViewModel>(providerContext);

                    // Initialize controllers and view model with task data
                    if (!_isInitialized && task != null) {
                      _titleController.text = task.title;
                      _descriptionController.text = task.description ?? '';
                      viewModel.init(task);
                      _isInitialized = true;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.edit, size: 24),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                            hintText: 'Edit task title',
                            labelText: 'Title',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            errorText: viewModel.errorMessage,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Due Date',
                            hintText: viewModel.selectedDate == null
                                ? 'YYYY-MM-DD'
                                : '${viewModel.selectedDate!.toLocal()}'.split(' ')[0],
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () => DatePickerHelper.showDatePickerDialog(
                              context: context, initialDate: viewModel.selectedDate),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: 'Notes',
                            hintText: 'Edit description',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await viewModel.updateTask(
                                _titleController.text,
                                _descriptionController.text.isEmpty
                                    ? null
                                    : _descriptionController.text,
                                viewModel.selectedDate,
                              );
                              if (success && context.mounted) {
                                context.go(RouteNames.taskListScreen);
                              }
                            }
                          },
                          child: Text(
                            'Update Task',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                          onPressed: () async {
                            final success = await viewModel.deleteTask();
                            if (success && context.mounted) {
                              context.go(RouteNames.taskListScreen);
                            }
                          },
                          child: Text(
                            'Delete Task',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}