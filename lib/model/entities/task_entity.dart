class TaskEntity {
  static const String keyId = 'id';
  static const String keyTitle = 'title';
  static const String keyDescription = 'description';
  static const String keyDueDate = 'dueDate';
  static const String keyIsCompleted = 'isCompleted';

  final int? id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;

  TaskEntity({
    this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      keyId: id,
      keyTitle: title,
      keyDescription: description,
      keyDueDate: dueDate?.toIso8601String(),
      keyIsCompleted: isCompleted ? 1 : 0,
    };
  }

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map[keyId],
      title: map[keyTitle],
      description: map[keyDescription],
      dueDate: map[keyDueDate] != null ? DateTime.parse(map[keyDueDate]) : null,
      isCompleted: map[keyIsCompleted] == 1,
    );
  }
}
