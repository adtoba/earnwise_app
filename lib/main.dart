import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/utils/size_config.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
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

  userId = await LocalStorageService.get(PrefKeys.userId);
  firstName = await LocalStorageService.get(PrefKeys.userFirstName);
  lastName = await LocalStorageService.get(PrefKeys.userLastName);
  email = await LocalStorageService.get(PrefKeys.userEmail);
  profilePicture = await LocalStorageService.get(PrefKeys.userImageUrl);
  userExpertId = await LocalStorageService.get(PrefKeys.userExpertId);
  country = await LocalStorageService.get(PrefKeys.userCountry);
  state = await LocalStorageService.get(PrefKeys.userState);
  city = await LocalStorageService.get(PrefKeys.userCity);
  street = await LocalStorageService.get(PrefKeys.userStreet);
  zip = await LocalStorageService.get(PrefKeys.userZip);
  gender = await LocalStorageService.get(PrefKeys.userGender);
  phone = await LocalStorageService.get(PrefKeys.userPhone);


  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SizeConfig.init(context);
        return MaterialApp(
          locale: const Locale('en', 'US'),
          navigatorKey: navigatorKey,
          title: 'EarnWise',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          builder: (context, child) {
            return StyledToast(child: child ?? const SizedBox.shrink());
          },
          home: OnboardingScreen(),
        );
      }
    );
  }
}