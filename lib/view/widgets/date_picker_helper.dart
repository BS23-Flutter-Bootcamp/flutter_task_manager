import 'package:flutter/material.dart';

class DatePickerHelper {
  static Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    required DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2101),
    );
  }
}
