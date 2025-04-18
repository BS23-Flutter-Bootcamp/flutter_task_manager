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

  // Database constants
  static const String databaseName = 'tasks.db';
  static const String tableName = 'tasks';
  static const int version = 1;

  // Error messages
  static const String errorTitleRequired = 'Please enter a title';
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
}
