import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/detail_card.dart';
import 'package:go_router/go_router.dart';

class DetailsPageScreen extends StatelessWidget {
  const DetailsPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = GoRouterState.of(context).extra as TaskEntity?;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 191, 173, 227),
                Color.fromARGB(255, 164, 145, 197),
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
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child:
            task == null
                ? Center(
                  child: Text(
                    'No Task Details Available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              DetailCard(
                                title: 'Title',
                                value: task.title,
                                icon: Icons.title,
                              ),
                              DetailCard(
                                title: 'Description',
                                value:
                                    task.description ??
                                    'No description available',
                                icon: Icons.description,
                              ),
                              DetailCard(
                                title: 'Due Date',
                                value:
                                    task.dueDate != null
                                        ? '${task.dueDate!.toLocal()}'.split(
                                          ' ',
                                        )[0]
                                        : 'No due date set',
                                icon: Icons.calendar_today,
                              ),
                              DetailCard(
                                title: 'Status',
                                value:
                                    task.isCompleted
                                        ? 'Completed'
                                        : 'Incomplete',
                                icon: Icons.check_circle_outline,
                              ),
                              const SizedBox(height: 24),

                              ElevatedButton(
                                onPressed:
                                    () => context.go(
                                      RouteNames.editTaskScreen,
                                      extra: task,
                                    ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Edit Task',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
