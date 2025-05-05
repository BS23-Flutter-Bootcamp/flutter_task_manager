import 'package:flutter/material.dart';
import 'package:flutter_task_manager/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginTextFields extends StatelessWidget {
  const LoginTextFields({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<LoginViewModel>(context);

    return Column(
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            viewModel.setEmail(value);
          },
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: theme.hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!RegExp(
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
            ).hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: !viewModel.showPassword,
          obscuringCharacter: '*',
          onChanged: (value) {
            viewModel.setPassword(value);
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                viewModel.togglePasswordVisibility(!viewModel.showPassword);
              },
            ),
            labelText: 'Password',
            labelStyle: TextStyle(color: theme.hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            if (!RegExp(
              r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$',
            ).hasMatch(value)) {
              return 'Password must contain at least one letter and one number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
