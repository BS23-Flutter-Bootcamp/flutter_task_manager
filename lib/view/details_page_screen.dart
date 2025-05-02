import 'package:flutter/material.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/detail_card.dart';
import 'package:flutter_task_manager/view/widgets/details_task_bar.dart';
import 'package:flutter_task_manager/view/widgets/task_button.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

class DetailsPageScreen extends StatelessWidget {
  const DetailsPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final task = GoRouterState.of(context).extra as TaskEntity?;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade50, // Use explicit shade
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child:
              task == null
                  ? Center(
                    child: Text(
                      'No Task Details Available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      DetailsTaskBar(text: 'Task Details'),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SingleChildScrollView(
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 600),
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
                                            ? '${task.dueDate!.toLocal()}'
                                                .split(' ')[0]
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
                                  TaskButton(
                                    text: 'Edit Task',
                                    icon: Icons.edit,
                                    onTap: () {
                                      context.go(
                                        RouteNames.editTaskScreen,
                                        extra: task,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
