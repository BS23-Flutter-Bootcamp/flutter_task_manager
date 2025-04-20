import 'package:flutter/material.dart';

/// A reusable form widget for task title, description, and due date inputs.
class TaskForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final DateTime? selectedDate;
  final String? errorMessage;
  final VoidCallback onDateTap;

  const TaskForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedDate,
    this.errorMessage,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.edit, size: 24),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            hintText: 'Task title',
            labelText: 'Title',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            errorText: errorMessage,
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
            hintText:
                selectedDate == null
                    ? 'YYYY-MM-DD'
                    : '${selectedDate!.toLocal()}'.split(' ')[0],
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: onDateTap,
          validator: (value) {
            if (selectedDate == null) {
              return 'Please select a due date';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.description),
            labelText: 'Notes',
            hintText: 'Task description',
          ),
        ),
      ],
    );
  }
}
