import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertHomeWalletView extends StatelessWidget {
  const ExpertHomeWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(16), vertical: config.sh(16)),
        decoration: BoxDecoration(
          color: isDarkMode ? Palette.darkFillColor : Palette.lightBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Palette.borderDark : Palette.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Wallet Balance",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.smallRegular.copyWith(
                fontFamily: TextStyles.fontFamily,
                color: isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light,
              ),
            ),
            YMargin(6),
            Text(
              "\$0.00",
              style: TextStyles.h4Bold.copyWith(
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
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
                      "Withdraw",
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
                      "Top Up",
                      style: TextStyles.mediumSemiBold.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}