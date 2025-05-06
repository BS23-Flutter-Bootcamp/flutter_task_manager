import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_task_manager/config/firebase_options.dart';
import 'package:flutter_task_manager/model/repositories/login_repository.dart';
import 'package:flutter_task_manager/model/repositories/sign_up_repository.dart';
import 'package:flutter_task_manager/model/services/login_service.dart';
import 'package:flutter_task_manager/model/services/sign_up_service.dart';
import 'package:flutter_task_manager/routing/app_route.dart';
import 'package:flutter_task_manager/view/theme/app_theme.dart';
import 'package:flutter_task_manager/viewmodel/login_view_model.dart';
import 'package:flutter_task_manager/viewmodel/sign_up_view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider<LoginService>(create: (context) => LoginService()),
        Provider<LoginRepository>(
          create:
              (context) =>
                  LoginRepository(loginService: context.read<LoginService>()),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create:
              (context) => LoginViewModel(
                loginRepository: context.read<LoginRepository>(),
              ),
        ),

        Provider<SignUpService>(create: (context) => SignUpService()),
        Provider<SignUpRepository>(
          create:
              (context) =>
                  SignUpRepository(signUpService: context.read<SignUpService>()),
        ),
        ChangeNotifierProvider<SignUpViewModel>(
          create:
              (context) => SignUpViewModel(
                signUpRepository: context.read<SignUpRepository>(),
              ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.build(),
    );
  }
}
