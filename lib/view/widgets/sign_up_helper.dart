import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/toast_snackbar.dart';
import 'package:flutter_task_manager/viewmodel/sign_up_screen_view_model.dart';
import 'package:go_router/go_router.dart';

class SignUpHelper {
   static Future<void> handleSignUp({required BuildContext context,required SignUpViewModel viewModel}) async {
   
    final success = await viewModel.signUp();
    if (success && context.mounted) {
      ToastSnackbar.show(
        context: context,
        message: 'Account created successfully! Please verify your email.',
        color: Colors.green[300]!,
      );
      context.go(RouteNames.taskListScreen);
    }
  }

  static void handleGoogleSignIn(BuildContext context) {
    ToastSnackbar.show(
      context: context,
      message: 'Google Sign In not implemented',
      color: Colors.red[300]!,
    );
  }

  static void handleFacebookSignIn(BuildContext context) {
    ToastSnackbar.show(
      context: context,
      message: 'Facebook Sign In not implemented',
      color: Colors.red[300]!,
    );
  
  }

  static void handleAppleSignIn(BuildContext context) {
    ToastSnackbar.show(
      context: context,
      message: 'Apple Sign In not implemented',
      color: Colors.red[300]!,
    );
  }
}