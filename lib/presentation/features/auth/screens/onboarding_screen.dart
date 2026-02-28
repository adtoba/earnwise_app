import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:earnwise_app/core/providers/auth_provider.dart';
import 'package:earnwise_app/core/utils/extensions.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/data/services/local_storage_service.dart';
import 'package:earnwise_app/presentation/features/auth/screens/login_screen.dart';
import 'package:earnwise_app/presentation/features/auth/widgets/auth_button.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/expert_dashboard_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Palette.darkBackground
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //   Colors.white,
            //   Color(0xFF0B0F19),
            //   ],
            // ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
            child: Column(
              children: [
                YMargin(60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "logo".png,
                      width: config.sw(30),
                      height: config.sh(30),
                    ),
                    XMargin(10),
                    Text(
                      "EarnWise",
                      style: TextStyles.h4Bold.copyWith(
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                // Text(
                //   "Create your account to get started",
                //   style: TextStyles.largeBold,
                // ),
                YMargin(10),
                AuthButton(
                  text: "Continue with Email",
                  onPressed: () async {
                    bool? isLoggedIn = await LocalStorageService.get(PrefKeys.isLoggedIn);
                    if(isLoggedIn == true) {
                      bool? isExpertMode = await LocalStorageService.get(PrefKeys.isExpertMode);
                      if(isExpertMode == true) {
                        pushAndRemoveUntil(const ExpertDashboardScreen());
                      } else {
                        pushAndRemoveUntil(const DashboardScreen());
                      }
                    } else {
                      push(LoginScreen());
                    }
                  },
                  isLoading: false,
                  color: Palette.primary,
                  prefixIcon: "email".png,
                ),
                YMargin(10),
                AuthButton(
                  text: "Continue with Google",
                  onPressed: () {
                    ref.read(authNotifier).googleAuth();
                  },
                  isLoading: false,
                  color: Colors.white,
                  prefixIcon: "google".png,
                ),
                YMargin(10),
                AuthButton(
                  text: "Continue with Apple",
                  onPressed: () {},
                  isLoading: false,
                  color: Colors.white,
                  prefixIcon: "apple".png,
                ),
                YMargin(20),
                Text(
                  "By continuing, you agree to our Terms and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyles.smallRegular.copyWith(
                    color: Colors.white
                  ),
                ),
                YMargin(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}