import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_set_availability_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/expert_socials_screen.dart';
import 'package:earnwise_app/presentation/features/expert/screens/set_rates_screen.dart';
import 'package:earnwise_app/presentation/features/profile/screens/profile_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_details_screen.dart';
import 'package:earnwise_app/presentation/features/settings/screens/expert_reviews_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertSettingsScreen extends StatefulWidget {
  const ExpertSettingsScreen({super.key});

  @override
  State<ExpertSettingsScreen> createState() => _ExpertSettingsScreenState();
}

class _ExpertSettingsScreenState extends State<ExpertSettingsScreen> {
  bool _expertMode = true;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

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
          Container(
            padding: EdgeInsets.all(config.sw(14)),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: config.sw(28),
                  backgroundImage: const NetworkImage(
                    "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                  ),
                ),
                XMargin(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jose Martinez",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling,
                        style: TextStyles.largeSemiBold.copyWith(
                          color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                        ),
                      ),
                      YMargin(4),
                      Text(
                        "@josemartinez",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling,
                        style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ),
                XMargin(10),
                OutlinedButton(
                  onPressed: () {
                    push(ProfileScreen());
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    foregroundColor: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: config.sw(12), vertical: config.sh(8)),
                  ),
                  child: Text(
                    "View Profile",
                    style: TextStyles.smallSemiBold,
                  ),
                ),
              ],
            ),
          ),
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
          _SettingsTile(
            title: "Expert Details",
            icon: Icons.person_outline,
            isDarkMode: isDarkMode,
            onTap: () {
              push(ExpertDetailsScreen());
            },
          ),
          _SettingsTile(
            title: "Your Rates",
            icon: Icons.sell_outlined,
            isDarkMode: isDarkMode,
            onTap: () {
              push(SetRatesScreen());
            },
          ),
          _SettingsTile(
            title: "Set Availability",
            icon: Icons.calendar_today_outlined,
            isDarkMode: isDarkMode,
            showDivider: true,
            onTap: () {
              push(ExpertSetAvailabilityScreen());
            },
          ),
          _SettingsTile(
            title: "Linked Socials",
            icon: Icons.link_outlined,
            isDarkMode: isDarkMode,
            showDivider: true,
            onTap: () {
              push(ExpertSocialsScreen());
            },
          ),
          _SettingsTile(
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
          _SettingsTile(
            title: "Wallet",
            icon: Icons.account_balance_wallet_outlined,
            isDarkMode: isDarkMode,
          ),
          _SettingsTile(
            title: "Transactions",
            icon: Icons.receipt_long_outlined,
            isDarkMode: isDarkMode,
          ),
          YMargin(20),
          _SettingsSectionTitle(
            title: "Preferences",
            isDarkMode: isDarkMode,
          ),
          _SettingsTile(
            title: "Notifications",
            icon: Icons.notifications_none_outlined,
            isDarkMode: isDarkMode,
          ),
          _SettingsTile(
            title: "Privacy & Security",
            icon: Icons.lock_outline,
            isDarkMode: isDarkMode,
          ),
          _SettingsTile(
            title: "Help & Support",
            icon: Icons.support_agent_outlined,
            isDarkMode: isDarkMode,
            showDivider: false,
          ),
          YMargin(20),
          _SettingsSectionTitle(
            title: "Legal",
            isDarkMode: isDarkMode,
          ),
          _SettingsTile(
            title: "Terms & Conditions",
            icon: Icons.description_outlined,
            isDarkMode: isDarkMode,
          ),
          _SettingsTile(
            title: "Privacy Policy",
            icon: Icons.privacy_tip_outlined,
            isDarkMode: isDarkMode,
            showDivider: false,
          ),
          YMargin(20),
          TextButton.icon(
            onPressed: () {},
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

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.icon,
    required this.isDarkMode,
    this.showDivider = true,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isDarkMode;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final dividerColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final iconColor = _iconColor(icon, isDarkMode);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
          title: Text(
            title,
            style: TextStyles.mediumSemiBold.copyWith(
              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: secondaryTextColor,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: config.sh(12),
            color: dividerColor,
          ),
      ],
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