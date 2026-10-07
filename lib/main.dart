import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppState.instance.initialize();

  runApp(const MyPhoneApp());
}

class MyPhoneApp extends StatelessWidget {
  const MyPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Phone',
          theme: AppTheme.lightTheme,
          home: AppState.instance.isLoggedIn
              ? const HomePage()
              : const LoginPage(),
        );
      },
    );
  }
}
