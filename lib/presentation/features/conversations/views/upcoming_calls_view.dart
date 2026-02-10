import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class UpcomingCallsView extends StatefulWidget {
  const UpcomingCallsView({super.key});

  @override
  State<UpcomingCallsView> createState() => _UpcomingCallsViewState();
}

class _UpcomingCallsViewState extends State<UpcomingCallsView> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final cardShadow = isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.06);
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final chipBg = isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
      itemBuilder: (c, i) {
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: cardShadow,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: config.sw(16), vertical: config.sh(8)),
            childrenPadding: EdgeInsets.fromLTRB(config.sw(16), 0, config.sw(16), config.sh(16)),
            leading: Container(
              height: config.sw(44),
              width: config.sw(44),
              decoration: BoxDecoration(
                color: Palette.primary.withOpacity(isDarkMode ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.call, color: Palette.primary),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.centerLeft,
            title: Text(
              "Jose Martinez",
              style: TextStyles.largeBold.copyWith(
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
            ),
            subtitle: Text(
              "Today, 10:00 AM",
              style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
            ),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: chipBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Upcoming",
                      style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                    ),
                  ),
                  XMargin(10),
                  Icon(Icons.timer_outlined, size: 16, color: secondaryTextColor),
                  XMargin(6),
                  Text(
                    "30 mins",
                    style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                  ),
                ],
              ),
              YMargin(12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Subject:",
                    style: TextStyles.smallSemiBold.copyWith(
                      color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                    ),
                  ),
                  XMargin(8),
                  Expanded(
                    child: Text(
                      "Investment Strategy",
                      style: TextStyles.smallMedium.copyWith(color: secondaryTextColor),
                    ),
                  ),
                ],
              ),
              YMargin(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description:",
                    style: TextStyles.smallSemiBold.copyWith(
                      color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                    ),
                  ),
                  XMargin(8),
                  Expanded(
                    child: Text(
                      "Discuss current holdings, risk tolerance, and short-term goals. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      style: TextStyles.smallMedium.copyWith(color: secondaryTextColor),
                    ),
                  ),
                ],
              ),
              YMargin(16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDarkMode ? Palette.borderDark : Palette.borderLight),
                        foregroundColor: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyles.mediumSemiBold,
                      ),
                    ),
                  ),
                  XMargin(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: config.sh(12)),
                      ),
                      child: Text(
                        "Join",
                        style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }, 
      separatorBuilder: (c, i) => YMargin(10), 
      itemCount: 7
    );
  }
}