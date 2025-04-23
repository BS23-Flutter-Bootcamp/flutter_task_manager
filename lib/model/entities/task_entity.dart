import 'package:flutter_task_manager/constants/app_constants.dart';

class TaskEntity {
  TaskEntity({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.lastSyncTime,
    required this.email,
  });

  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? lastSyncTime;
  final String email;

  Map<String, dynamic> toMap() {
    return {
      AppConstants.keyId: id,
      AppConstants.keyTitle: title,
      AppConstants.keyDescription: description,
      AppConstants.keyDueDate: dueDate?.toIso8601String(),
      AppConstants.keyIsCompleted: isCompleted ? 1 : 0,
      AppConstants.keyLastSyncTime: lastSyncTime?.toIso8601String(),
      AppConstants.keyEmail: email,
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map[AppConstants.keyId],
      title: map[AppConstants.keyTitle],
      description: map[AppConstants.keyDescription],
      dueDate: map[AppConstants.keyDueDate] != null
          ? DateTime.parse(map[AppConstants.keyDueDate])
          : null,
      isCompleted: map[AppConstants.keyIsCompleted] == 1,
      lastSyncTime: map[AppConstants.keyLastSyncTime] != null
          ? DateTime.parse(map[AppConstants.keyLastSyncTime])
          : null,
      email: map[AppConstants.keyEmail],
    );
  }

  // For Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      AppConstants.keyId: id,
      AppConstants.keyTitle: title,
      AppConstants.keyDescription: description,
      AppConstants.keyDueDate: dueDate?.toIso8601String(),
      AppConstants.keyIsCompleted: isCompleted,
      AppConstants.keyLastSyncTime: lastSyncTime?.toIso8601String(),
      AppConstants.keyEmail: email,
    };
  }

  factory TaskEntity.fromFirestore(Map<String, dynamic> map) {
    return TaskEntity(
      id: map[AppConstants.keyId],
      title: map[AppConstants.keyTitle],
      description: map[AppConstants.keyDescription],
      dueDate: map[AppConstants.keyDueDate] != null
          ? DateTime.parse(map[AppConstants.keyDueDate])
          : null,
      isCompleted: map[AppConstants.keyIsCompleted] ?? false,
      lastSyncTime: map[AppConstants.keyLastSyncTime] != null
          ? DateTime.parse(map[AppConstants.keyLastSyncTime])
          : null,
      email: map[AppConstants.keyEmail],
    );
  }
}