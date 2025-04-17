import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routes/app_route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.add, size: 24),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  hintText: 'Add Sub-task',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
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
                controller: _dateController,
                readOnly: true, // Prevents manual text input
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.deepPurple,
                  ),
                ),
                onTap: () => _selectDate(context),
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,

                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  labelText: 'notes',
                  hintText: 'Add description',
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RouteNames.taskListScreen);
                    }
                  }
                },
                child: const Text('Add Task', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
