import 'package:flutter_task_manager/constants/app_constants.dart';

class TaskEntity {
  TaskEntity({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  
  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;

  Map<String, dynamic> toMap() {
    return {
      AppConstants.keyId: id,
      AppConstants.keyTitle: title,
      AppConstants.keyDescription: description,
      AppConstants.keyDueDate: dueDate?.toIso8601String(),
      AppConstants.keyIsCompleted: isCompleted ? 1 : 0,
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map[AppConstants.keyId],
      title: map[AppConstants.keyTitle],
      description: map[AppConstants.keyDescription],
      dueDate:
          map[AppConstants.keyDueDate] != null
              ? DateTime.parse(map[AppConstants.keyDueDate])
              : null,
      isCompleted: map[AppConstants.keyIsCompleted] == 1,
    );
  }
}
