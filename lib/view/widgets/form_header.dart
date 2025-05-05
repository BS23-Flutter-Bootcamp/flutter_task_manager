import 'package:flutter/material.dart';

class FormHeader extends StatelessWidget {
  final String appTitle;
  final String formTitle;

  const FormHeader({
    super.key,
    required this.appTitle,
    required this.formTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          appTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          formTitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
