import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/expert/screens/become_expert_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class BecomeExpertModal extends StatelessWidget {
  const BecomeExpertModal({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
      decoration: BoxDecoration(
        color: isDarkMode ? Palette.darkFillColor : Palette.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: config.sh(4),
            width: config.sw(40),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Palette.borderLight,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          YMargin(16),
          Icon(Icons.workspace_premium_outlined, size: 40, color: Palette.primary),
          YMargin(12),
          Text(
            "Become an Expert",
            style: TextStyles.largeBold.copyWith(
              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
            ),
          ),
          YMargin(8),
          Text(
            "Share your knowledge, set your rates, and start earning by helping people with your expertise.",
            textAlign: TextAlign.center,
            style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
          ),
          YMargin(16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(config.sw(14)),
            decoration: BoxDecoration(
              color: isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDarkMode ? Palette.borderDark : Palette.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  title: "Set your rates",
                  subtitle: "Charge for text, audio, video responses and calls.",
                ),
                YMargin(10),
                _InfoRow(
                  title: "Manage your time",
                  subtitle: "Control availability and accept requests on your schedule.",
                ),
                YMargin(10),
                _InfoRow(
                  title: "Grow your profile",
                  subtitle: "Get reviews and build trust with clients.",
                ),
              ],
            ),
          ),
          YMargin(16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.play_circle_outline, color: Palette.primary),
            label: Text(
              "Watch intro video",
              style: TextStyles.mediumSemiBold.copyWith(color: Palette.primary),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(vertical: config.sh(12)),
            ),
          ),
          YMargin(16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    push(BecomeExpertScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          YMargin(50),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, size: 18, color: Palette.primary),
        XMargin(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.mediumSemiBold,
              ),
              YMargin(2),
              Text(
                subtitle,
                style: TextStyles.smallRegular.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}