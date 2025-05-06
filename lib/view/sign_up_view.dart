import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/form_header.dart';
import 'package:flutter_task_manager/view/widgets/login_sign_up_link.dart';
import 'package:flutter_task_manager/view/widgets/sign_up_helper.dart';
import 'package:flutter_task_manager/view/widgets/social_icons.dart';
import 'package:flutter_task_manager/viewmodel/sign_up_view_model.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<SignUpViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       FormHeader(
                          appTitle: 'Task Manager',
                          formTitle: 'Sign Up',
                        ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: viewModel.setEmail,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: theme.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          errorText: viewModel.emailError,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: viewModel.setPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: theme.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          errorText: viewModel.passwordError,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: viewModel.setRepeatPassword,
                        decoration: InputDecoration(
                          labelText: 'Repeat Password',
                          labelStyle: TextStyle(color: theme.hintColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          errorText: viewModel.repeatPasswordError,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sign up with social account',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SocialIcons(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            viewModel.isFormValid && !viewModel.isLoading
                                ? () {
                                  SignUpHelper.handleSignUp(
                                    context: context,
                                    viewModel: viewModel,
                                  );
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              viewModel.isFormValid
                                  ? theme.primaryColor
                                  : theme.primaryColor.withAlpha(128),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child:
                            viewModel.isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'SIGN UP',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 16),
                      if (viewModel.errorMessage != null)
                        Text(
                          viewModel.errorMessage!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 16),
                    LoginSignUpLink(isLoading: viewModel.isLoading,routeName: RouteNames.loginScreen,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
