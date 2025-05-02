import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/viewmodel/task_list_view_model.dart';

class TaskActionHandler {
  static Future<void> deleteTask({
    required BuildContext context,
    required TaskEntity task,
    required TaskListViewModel viewModel,
  }) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await viewModel.deleteTask(id: task.id);
      viewModel.fetchTasks(sync: true);
    }
  }
}