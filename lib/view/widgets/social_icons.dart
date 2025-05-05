import 'package:flutter/material.dart';
import 'package:flutter_task_manager/view/widgets/toast_snackbar.dart';
import 'package:flutter_task_manager/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    return Column(
      children: [
         Text(
          'Sign in with social account',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            IconButton(
              icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
              onPressed:
                  viewModel.isLoading
                      ? null
                      : () => ToastSnackbar.show(
                        context: context,
                        message: 'Google Sign In not implemented',
                        color: Colors.red[300]!,
                      ),
            ),
            IconButton(
              icon: const Icon(Icons.facebook, color: Colors.blue, size: 30),
              onPressed:
                  viewModel.isLoading
                      ? null
                      : () => ToastSnackbar.show(
                        context: context,
                        message: 'Facebook Sign In not implemented',
                        color: Colors.red[300]!,
                      ),
            ),
            IconButton(
              icon: const Icon(Icons.apple, color: Colors.black, size: 30),
              onPressed:
                  viewModel.isLoading
                      ? null
                      : () => ToastSnackbar.show(
                        context: context,
                        message: 'Apple Sign In not implemented',
                        color: Colors.red[300]!,
                      ),
            ),
          ],
        ),
      ],
    );
  }
}
