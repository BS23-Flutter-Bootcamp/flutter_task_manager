
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:go_router/go_router.dart';

class LoginSignUpLink extends StatelessWidget {
  
  const LoginSignUpLink({super.key, required this.isLoading, required this.routeName});

  final bool isLoading;
  final String routeName;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: isLoading ? null : () => context.go(routeName),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: routeName == RouteNames.loginScreen?'Already have an account? ':'Don\'t have an account? ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: routeName == RouteNames.loginScreen?'Login':'Sign Up',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
