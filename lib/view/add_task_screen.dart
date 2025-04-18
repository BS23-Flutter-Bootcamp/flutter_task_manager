import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routes/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/task_form.dart';
import 'package:flutter_task_manager/viewmodel/add_task_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}


class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, AddTaskViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      viewModel.setSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTaskViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Task'),
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
            child: Consumer<AddTaskViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TaskForm(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      selectedDate: viewModel.selectedDate,
                      errorMessage: viewModel.errorMessage,
                      onDateTap: () => _selectDate(context, viewModel),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await viewModel.addTask(
                                  _titleController.text,
                                  _descriptionController.text.isEmpty
                                      ? null
                                      : _descriptionController.text,
                                  viewModel.selectedDate,
                                );
                                if (success && context.mounted) {
                                  _titleController.clear();
                                  _descriptionController.clear();
                                  context.go(RouteNames.taskListScreen);
                                }
                              }
                            },
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Add Task',
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}