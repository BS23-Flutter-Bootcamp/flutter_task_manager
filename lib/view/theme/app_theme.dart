import 'package:flutter/material.dart';
import 'package:flutter_task_manager/constants/app_constants.dart';

class AppTheme {
  static ThemeData build() {
    return ThemeData(
      primaryColor: AppConstants.primaryColor,
      hintColor: AppConstants.hintColor,
      scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppConstants.textColorDark),
        bodyMedium: TextStyle(color: AppConstants.textColorLight),
      ),
      appBarTheme: AppBarTheme(color: AppConstants.textColorDark),
    );
  }
}
