import 'package:earnwise_app/core/utils/size_config.dart';
import 'package:earnwise_app/presentation/features/auth/screens/login_screen.dart';
import 'package:earnwise_app/presentation/features/auth/screens/onboarding_screen.dart';
import 'package:earnwise_app/presentation/styles/theme.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SizeConfig.init(context);
        // SizeConfig.update(context);
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'EarnWise',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          home: OnboardingScreen()
        );
      }
    );
  }
}