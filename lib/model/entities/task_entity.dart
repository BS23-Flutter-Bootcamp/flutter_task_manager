import 'package:flutter_task_manager/constants/app_constants.dart';

class TaskEntity {
  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime? lastSyncTime;
  final String email;
  final bool isDeleted;

  TaskEntity({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.lastSyncTime,
    required this.email,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.keyId: id,
      AppConstants.keyTitle: title,
      AppConstants.keyDescription: description,
      AppConstants.keyDueDate: dueDate?.toIso8601String(),
      AppConstants.keyIsCompleted: isCompleted ? 1 : 0,
      AppConstants.keyLastSyncTime: lastSyncTime?.toIso8601String(),
      AppConstants.keyEmail: email,
      AppConstants.keyIsDeleted: isDeleted ? 1 : 0,
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
      isDeleted: map[AppConstants.keyIsDeleted] == 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      AppConstants.keyId: id,
      AppConstants.keyTitle: title,
      AppConstants.keyDescription: description,
      AppConstants.keyDueDate: dueDate?.toIso8601String(),
      AppConstants.keyIsCompleted: isCompleted,
      AppConstants.keyLastSyncTime: lastSyncTime?.toIso8601String(),
      AppConstants.keyEmail: email,
      AppConstants.keyIsDeleted: isDeleted,
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
      isDeleted: map[AppConstants.keyIsDeleted] ?? false,
    );
  }

  TaskEntity copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? lastSyncTime,
    String? email,
    bool? isDeleted,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      email: email ?? this.email,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}