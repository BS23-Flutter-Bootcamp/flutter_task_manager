import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
import 'package:flutter_task_manager/view/widgets/sign_up_helper.dart';
import 'package:flutter_task_manager/viewmodel/sign_up_screen_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreenView extends StatelessWidget {
  const SignUpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Builder(
          builder: (BuildContext providerContext) {
            return ListenableBuilder(
              listenable: Provider.of<SignUpViewModel>(
                providerContext,
                listen: false,
              ),
              builder: (context, child) {
                final viewModel = Provider.of<SignUpViewModel>(providerContext);
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
                            Text(
                              'Flutter Task Manager',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sign Up',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed:
                                      viewModel.isLoading
                                          ? null
                                          : () =>
                                              SignUpHelper.handleGoogleSignIn(
                                                providerContext,
                                              ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.facebook,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  onPressed:
                                      viewModel.isLoading
                                          ? null
                                          : () =>
                                              SignUpHelper.handleFacebookSignIn(
                                                providerContext,
                                              ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.apple,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  onPressed:
                                      viewModel.isLoading
                                          ? null
                                          : () =>
                                              SignUpHelper.handleAppleSignIn(
                                                providerContext,
                                              ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed:
                                  viewModel.isFormValid && !viewModel.isLoading
                                      ? () {
                                        SignUpHelper.handleSignUp(
                                          context: providerContext,
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
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
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
                            GestureDetector(
                              onTap:
                                  viewModel.isLoading
                                      ? null
                                      : () => providerContext.go(
                                        RouteNames.loginScreen,
                                      ),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Already have an account? ',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                    TextSpan(
                                      text: 'Login',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
