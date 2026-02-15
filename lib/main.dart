import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/utils/size_config.dart';
import 'package:earnwise_app/presentation/features/auth/screens/onboarding_screen.dart';
import 'package:earnwise_app/presentation/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/web.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await Hive.openBox(PrefKeys.appData);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StyledToast(

      child: Builder(
        builder: (context) {
          SizeConfig.init(context);
          // SizeConfig.update(context);
          return MaterialApp(
            locale: const Locale('en', 'US'),
            navigatorKey: navigatorKey,
            title: 'EarnWise',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            home: OnboardingScreen()
          );
        }
      ),
    );
  }
}