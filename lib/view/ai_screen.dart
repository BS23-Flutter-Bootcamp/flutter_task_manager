import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/viewmodel/ai_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AiViewModel(),
      child: Scaffold(
        appBar: AppBar(
              flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 191, 173, 227), // Deeper lavender
                  Color.fromARGB(
                    255,
                    164,
                    145,
                    197,
                  ), // Bold violet for contrast
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              context.go(RouteNames.taskListScreen);
            },
          ),
          title: const Text('Generate Task Plan'),
          backgroundColor: AppConstants.textColorDark,
        ),
        body: Consumer<AiViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter your prompt (e.g., "Plan a study schedule")',
                      border: OutlineInputBorder()
                    ),
                    maxLines: 3,
                    onChanged: viewModel.setPrompt,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () => viewModel.generateTasks(),
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Generate Tasks'),
                  ),
                  if (viewModel.errorMessage != null &&
                      !viewModel.errorMessage!.contains('prompt'))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Expanded(
                    child: viewModel.generatedTasks.isEmpty
                        ? const Center(child: Text('No tasks generated yet'))
                        : ListView.builder(
                            itemCount: viewModel.generatedTasks.length,
                            itemBuilder: (context, index) {
                              final task = viewModel.generatedTasks[index];
                              return TaskPreviewCard(
                                task: task,
                                onUpdate: (updatedTask) {
                                  viewModel.updateTask(index, updatedTask);
                                },
                              );
                            },
                          ),
                  ),
                  if (viewModel.generatedTasks.isNotEmpty)
                    ElevatedButton(
                      onPressed: viewModel.isLoading ? null : () => viewModel.saveTasks(),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Save Tasks'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskPreviewCard extends StatefulWidget {
  final TaskEntity task;
  final Function(TaskEntity) onUpdate;

  const TaskPreviewCard({super.key, required this.task, required this.onUpdate});

  @override
  TaskPreviewCardState createState() => TaskPreviewCardState();
}

class TaskPreviewCardState extends State<TaskPreviewCard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                widget.onUpdate(widget.task.copyWith(title: value));
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
              onChanged: (value) {
                widget.onUpdate(widget.task.copyWith(description: value));
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  _dueDate != null
                      ? 'Due: ${_dueDate!.toIso8601String().split('T')[0]}'
                      : 'No due date',
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dueDate = selectedDate;
                        widget.onUpdate(widget.task.copyWith(dueDate: _dueDate));
                      });
                    }
                  },
                  child: const Text('Change Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension TaskEntityCopy on TaskEntity {
  TaskEntity copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
  }) {
    return TaskEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted,
      lastSyncTime: lastSyncTime,
      email: email,
    );
  }
}