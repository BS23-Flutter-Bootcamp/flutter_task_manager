import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:intl/intl.dart';

/// A reusable widget for displaying a task in the task list.
class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onCheckboxChanged,
  });

  final TaskEntity task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          task.isCompleted
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        onTap: onTap,
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onCheckboxChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color:
                    task.isCompleted
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.titleMedium?.color,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              task.description ?? 'No description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Due Date: ${task.dueDate != null ? DateFormat.yMMMd().format(task.dueDate!) : 'No due date'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
