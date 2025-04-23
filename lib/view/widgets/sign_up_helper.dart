import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/viewmodel/sign_up_screen_view_model.dart';
import 'package:go_router/go_router.dart';

class SignUpHelper {
   static Future<void> handleSignUp({required BuildContext context,required SignUpViewModel viewModel}) async {
   
    final success = await viewModel.signUp();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully! Please verify your email.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go(RouteNames.taskListScreen);
    }
  }

  static void handleGoogleSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In not implemented')),
    );
  }

  static void handleFacebookSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook Sign In not implemented')),
    );
  }

  static void handleAppleSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign In not implemented')),
    );
  }
}