import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/form_header.dart';
import 'package:flutter_task_manager/view/widgets/loading_indicator.dart';
import 'package:flutter_task_manager/view/widgets/login_text_fields.dart';
import 'package:flutter_task_manager/view/widgets/sign_up_link.dart';
import 'package:flutter_task_manager/view/widgets/social_icons.dart';
import 'package:flutter_task_manager/viewmodel/login_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  void _handleLogin(LoginViewModel viewModel) async {
    if (_formKey.currentState!.validate()) {
      try {
        bool authenticated = await viewModel.login();
        if (authenticated && mounted) {
          context.go(RouteNames.taskListScreen);
          viewModel.setMessage('Sucessfully logged in.');
        }
      } catch (e) {
        viewModel.setMessage('Login failed. Password or email is incorrect.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Consumer<LoginViewModel>(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FormHeader(
                          appTitle: 'Task Manager',
                          formTitle: 'Login',
                        ),
                        const SizedBox(height: 20),
                        const LoginTextFields(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: viewModel.isRememberMeChecked,
                              onChanged: (value) {
                                viewModel.setRememberMe(value!);
                              },
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                        const SizedBox(height: 20),
      
                        SocialIcons(),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed:
                              !viewModel.isLoading
                                  ? () async {
                                    _handleLogin(viewModel);
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
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
                                  ? LoadingIndicator()
                                  : Text(
                                    'LOGIN',
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                  ),
                        ),
                        const SizedBox(height: 16),
                        if (viewModel.message != null)
                          Text(
                            viewModel.message!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        const SizedBox(height: 16),
                        SignUpLink(isLoading: viewModel.isLoading),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
