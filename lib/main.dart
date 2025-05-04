import 'package:flutter/material.dart';
import 'package:flutter_task_manager/config/app_initializer.dart';
import 'package:flutter_task_manager/routing/app_route.dart';
import 'package:flutter_task_manager/view/theme/app_theme.dart';
import 'package:flutter_task_manager/viewmodel/login_screen_view_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.build(),
      ),
    );
  }
}
