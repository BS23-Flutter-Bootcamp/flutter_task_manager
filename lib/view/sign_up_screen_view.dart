import 'package:flutter/material.dart';
import 'package:flutter_task_manager/routing/app_route_name.dart';
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
                          onChanged:
                              Provider.of<SignUpViewModel>(
                                providerContext,
                                listen: false,
                              ).setEmail,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: theme.hintColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            errorText:
                                Provider.of<SignUpViewModel>(
                                  providerContext,
                                ).emailError,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged:
                              Provider.of<SignUpViewModel>(
                                providerContext,
                                listen: false,
                              ).setPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: theme.hintColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            errorText:
                                Provider.of<SignUpViewModel>(
                                  providerContext,
                                ).passwordError,
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged:
                              Provider.of<SignUpViewModel>(
                                providerContext,
                                listen: false,
                              ).setRepeatPassword,
                          decoration: InputDecoration(
                            labelText: 'Repeat Password',
                            labelStyle: TextStyle(color: theme.hintColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            errorText:
                                Provider.of<SignUpViewModel>(
                                  providerContext,
                                ).repeatPasswordError,
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
                            _SocialSignInButton(
                              icon: Icons.g_mobiledata,
                              color: Colors.red,
                              isLoading:
                                  Provider.of<SignUpViewModel>(
                                    providerContext,
                                  ).isLoading,
                              onPressed:
                                  () => _handleGoogleSignIn(providerContext),
                            ),
                            _SocialSignInButton(
                              icon: Icons.facebook,
                              color: Colors.blue,
                              isLoading:
                                  Provider.of<SignUpViewModel>(
                                    providerContext,
                                  ).isLoading,
                              onPressed:
                                  () => _handleFacebookSignIn(providerContext),
                            ),
                            _SocialSignInButton(
                              icon: Icons.apple,
                              color: Colors.black,
                              isLoading:
                                  Provider.of<SignUpViewModel>(
                                    providerContext,
                                  ).isLoading,
                              onPressed:
                                  () => _handleAppleSignIn(providerContext),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed:
                              Provider.of<SignUpViewModel>(
                                        providerContext,
                                      ).isFormValid &&
                                      !Provider.of<SignUpViewModel>(
                                        providerContext,
                                      ).isLoading
                                  ? () => _handleSignUp(providerContext)
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Provider.of<SignUpViewModel>(
                                      providerContext,
                                    ).isFormValid
                                    ? theme.primaryColor
                                    : theme.primaryColor.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child:
                              Provider.of<SignUpViewModel>(
                                    providerContext,
                                  ).isLoading
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
                        if (Provider.of<SignUpViewModel>(
                              providerContext,
                            ).errorMessage !=
                            null)
                          Text(
                            Provider.of<SignUpViewModel>(
                              providerContext,
                            ).errorMessage!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap:
                              Provider.of<SignUpViewModel>(
                                    providerContext,
                                  ).isLoading
                                  ? null
                                  : () => providerContext.go(
                                    RouteNames.loginScreen,
                                  ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Login',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
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
        ),
      ),
    );
  }

  Future<void> _handleSignUp(BuildContext context) async {
    final viewModel = Provider.of<SignUpViewModel>(context, listen: false);
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

  void _handleGoogleSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign In not implemented')),
    );
  }

  void _handleFacebookSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Facebook Sign In not implemented')),
    );
  }

  void _handleAppleSignIn(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Sign In not implemented')),
    );
  }
}

class _SocialSignInButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SocialSignInButton({
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: isLoading ? null : onPressed,
    );
  }
}
