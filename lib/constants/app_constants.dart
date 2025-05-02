import 'package:flutter/material.dart';

class AppConstants {
  // Theme colors
  static const Color primaryColor = Color(0xFFB39DDB); // DeepPurple[200]
  static const Color hintColor = Color(0xFF78909C); // BlueGrey
  static const Color scaffoldBackgroundColor = Color(0xFFEDE7F6); // DeepPurple[50]
  static const Color textColorDark = Color(0xFF7E57C2); // DeepPurple[400]
  static const Color textColorLight = Color(0xFF9575CD); // DeepPurple[300]
  static const Color appBarColor = Color(0xFF448AFF); // BlueAccent
  static const String keyId = 'id';
  static const String keyTitle = 'title';
  static const String keyDescription = 'description';
  static const String keyDueDate = 'dueDate';
  static const String keyIsCompleted = 'isCompleted';
  static const String keyIsDeleted = 'isDeleted';

  // Database constants
  static const String databaseName = 'task_manager.db';
  static const String tableName = 'task_manager';
  static const int version = 2;
  static const String keyLastSyncTime = 'lastSyncTime';
  static const String keyEmail = 'email';

  // Error messages
  static const String errorTitleRequired = 'Please enter a title';
  static const String errorDateRequired = 'Please enter a due date';
  static const String errorTaskNotFound = 'No task to update or delete';
  static const String errorTaskAdd = 'Failed to add task. Please try again.';
  static const String errorTaskUpdate = 'Failed to update task. Please try again.';
  static const String errorTaskDelete = 'Failed to delete task. Please try again.';
  static const String errorDatabaseInit = 'Failed to initialize database';
  static const String errorDatabaseInsert = 'Failed to insert task';
  static const String errorDatabaseFetch = 'Failed to fetch tasks';
  static const String errorDatabaseUpdate = 'Failed to update task';
  static const String errorDatabaseDelete = 'Failed to delete task';
  static const String errorDatabaseClose = 'Failed to close database';
  static const String errorDatabaseSync = 'Offline mode: Sync unavailable';
  static const String errorLogout = 'Failed to log out. Please try again.';
  static const String errorLogin = 'Failed to login. Please try again.' ;
  static const String taskListTitle = 'Task List';
  static const String successSync = 'Tasks synced successfully';
  static const String errorSync = 'Failed to sync tasks. Please try again.';
  static const String syncTasksTooltip = 'Sync tasks with server';
  static const String noTasks = 'No tasks added yet';
  static const String generateTaskPlanTooltip = 'Generate a task plan';


}
