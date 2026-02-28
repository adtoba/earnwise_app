import 'dart:convert';

import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/providers/theme_provider.dart';
import 'package:earnwise_app/core/utils/size_config.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/data/services/onesignal_service.dart';
import 'package:earnwise_app/domain/models/user_profile_model.dart';
import 'package:earnwise_app/presentation/features/auth/screens/onboarding_screen.dart';
import 'package:earnwise_app/presentation/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/web.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  await Hive.initFlutter();
  await Hive.openBox(PrefKeys.appData);

  await dotenv.load(fileName: '.env');

  OnesignalService.initialize();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(themeNotifier).initTheme();
      var profile = await LocalStorageService.get(PrefKeys.profile);
      if(profile != null) {
        var profileModel = UserProfileModel.fromJson(jsonDecode(profile));
        ref.read(profileNotifier).storeProfile(profileModel);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(themeNotifier);

    return Builder(
      builder: (context) {
        SizeConfig.init(context);
        return MaterialApp(
          locale: const Locale('en', 'US'),
          navigatorKey: navigatorKey,
          title: 'EarnWise',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.currentTheme,
          builder: (context, child) {
            return StyledToast(child: child ?? const SizedBox.shrink());
          },
          home: OnboardingScreen(),
        );
      }
    );
  }
}