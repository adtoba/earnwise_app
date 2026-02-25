import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/settings_provider.dart';
import 'package:earnwise_app/core/providers/theme_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_set_availability_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_socials_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/set_rates_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_details_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_reviews_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/settings_screen.dart';
import 'package:earnwise_app/presentation/features/transactions/screens/transactions_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/profile_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpertSettingsScreen extends ConsumerStatefulWidget {
  const ExpertSettingsScreen({super.key});

  @override
  ConsumerState<ExpertSettingsScreen> createState() => _ExpertSettingsScreenState();
}

class _ExpertSettingsScreenState extends ConsumerState<ExpertSettingsScreen> {
  bool _expertMode = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(themeNotifier);
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    var settingsProvider = ref.watch(settingsNotifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyles.largeBold.copyWith(
            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        children: [
          ProfileDetailsWidget(),
          YMargin(16),
          _ModeSwitchRow(
            isExpertMode: _expertMode,
            isDarkMode: isDarkMode,
            onChanged: (value) {
              setState(() {
                _expertMode = value;
              });
              if (!value) {
                pushAndRemoveUntil(const DashboardScreen());
              }
            },
          ),
          YMargin(20),
          _SettingsSectionTitle(
            title: "Expert",
            isDarkMode: isDarkMode,
          ),
          SettingsTile(
            title: "Expert Details",
            icon: Icons.person_outline,
            isDarkMode: isDarkMode,
            onTap: () {
              push(ExpertDetailsScreen());
            },
          ),
          SettingsTile(
            title: "Your Rates",
            icon: Icons.sell_outlined,
            isDarkMode: isDarkMode,
            onTap: () {
              push(SetRatesScreen());
            },
          ),
          SettingsTile(
            title: "Set Availability",
            icon: Icons.calendar_today_outlined,
            isDarkMode: isDarkMode,
            showDivider: true,
            onTap: () {
              push(ExpertSetAvailabilityScreen(
                isEditMode: true,
              ));
            },
          ),
          SettingsTile(
            title: "Linked Socials",
            icon: Icons.link_outlined,
            isDarkMode: isDarkMode,
            showDivider: true,
            onTap: () {
              push(ExpertSocialsScreen(
                isEditMode: true,
              ));
            },
          ),
          SettingsTile(
            title: "Ratings & Reviews",
            icon: Icons.star_border,
            isDarkMode: isDarkMode,
            showDivider: false,
            onTap: () {
              push(ExpertReviewsScreen());
            },
          ),
          YMargin(20),
          _SettingsSectionTitle(
            title: "Finance",
            isDarkMode: isDarkMode,
          ),
          SettingsTile(
            title: "Wallet",
            icon: Icons.account_balance_wallet_outlined,
            isDarkMode: isDarkMode,
          ),
          SettingsTile(
            title: "Transactions",
            icon: Icons.receipt_long_outlined,
            isDarkMode: isDarkMode,
            onTap: () => push(TransactionsScreen()),
          ),
          YMargin(20),
          _SettingsSectionTitle(
            title: "Preferences",
            isDarkMode: isDarkMode,
          ),
          SettingsTile(
            title: "Dark Mode",
            icon: Icons.dark_mode_outlined,
            isDarkMode: isDarkMode,
            trailing: Switch(
              value: themeProvider.currentTheme == ThemeMode.dark, 
              onChanged: (value) {
                themeProvider.toggleTheme(isDarkMode: value);
              },
            ),
          ),
          SettingsTile(
            title: "Notifications",
            icon: Icons.notifications_none_outlined,
            isDarkMode: isDarkMode,
            onTap: () {
              settingsProvider.goToNotifications();
            },
          ),
          SettingsTile(
            title: "Privacy & Security",
            icon: Icons.lock_outline,
            isDarkMode: isDarkMode,
            onTap: () {
              settingsProvider.goToPrivacyAndSecurity();
            },
          ),
          SettingsTile(
            title: "Help & Support",
            icon: Icons.support_agent_outlined,
            isDarkMode: isDarkMode,
            showDivider: false,
            onTap: () {
              settingsProvider.goToHelpAndSupport();
            },
          ),
          YMargin(20),
          _SettingsSectionTitle(
            title: "Legal",
            isDarkMode: isDarkMode,
          ),
          SettingsTile(
            title: "Terms & Conditions",
            icon: Icons.description_outlined,
            isDarkMode: isDarkMode,
            onTap: () {
              settingsProvider.goToTermsAndConditions();
            },
          ),
          SettingsTile(
            title: "Privacy Policy",
            icon: Icons.privacy_tip_outlined,
            isDarkMode: isDarkMode,
            showDivider: false,
            onTap: () {
              settingsProvider.goToPrivacyPolicy();
            },
          ),
          YMargin(20),
          TextButton.icon(
            onPressed: () {
              settingsProvider.goToLogout();
            },
            icon: Icon(Icons.logout, color: Colors.red.shade400),
            label: Text(
              "Logout",
              style: TextStyles.mediumSemiBold.copyWith(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({
    required this.title,
    required this.isDarkMode,
  });

  final String title;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: config.sh(6)),
      child: Text(
        title,
        style: TextStyles.smallSemiBold.copyWith(
          color: isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light,
        ),
      ),
    );
  }
}

Color _iconColor(IconData icon, bool isDarkMode) {
  switch (icon) {
    case Icons.person_outline:
      return isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    case Icons.sell_outlined:
      return isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
    case Icons.calendar_today_outlined:
      return isDarkMode ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
    case Icons.account_balance_wallet_outlined:
      return isDarkMode ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
    case Icons.receipt_long_outlined:
      return isDarkMode ? const Color(0xFFC4B5FD) : const Color(0xFF7C3AED);
    case Icons.star_border:
      return isDarkMode ? const Color(0xFFFDE047) : const Color(0xFFF59E0B);
    case Icons.notifications_none_outlined:
      return isDarkMode ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E);
    case Icons.lock_outline:
      return isDarkMode ? const Color(0xFFA3E635) : const Color(0xFF3F6212);
    case Icons.description_outlined:
      return isDarkMode ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6);
    case Icons.privacy_tip_outlined:
      return isDarkMode ? const Color(0xFFFBCFE8) : const Color(0xFFDB2777);
    case Icons.support_agent_outlined:
      return isDarkMode ? const Color(0xFFFDA4AF) : const Color(0xFFE11D48);
    default:
      return isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
  }
}

class _ModeSwitchRow extends StatelessWidget {
  const _ModeSwitchRow({
    required this.isExpertMode,
    required this.isDarkMode,
    required this.onChanged,
  });

  final bool isExpertMode;
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
       Text(
          "Expert Mode",
          style: TextStyles.mediumSemiBold.copyWith(color: textColor),
        ),
        XMargin(10),
        Switch.adaptive(
          value: isExpertMode,
          activeColor: Palette.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}