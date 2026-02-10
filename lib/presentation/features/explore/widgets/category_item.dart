import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category, required this.onTap, this.icon});

  final String category;
  final VoidCallback onTap;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
        decoration: BoxDecoration(
          color: isDarkMode ? Palette.darkFillColor : Palette.lightBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDarkMode ? Palette.borderDark : Palette.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.18 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: config.sw(36),
              width: config.sw(36),
              decoration: BoxDecoration(
                color: Palette.primary.withOpacity(isDarkMode ? 0.2 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.category_outlined,
                size: 18,
                color: Palette.primary,
              ),
            ),
            YMargin(10),
            Hero(
              tag: category,
              transitionOnUserGestures: true,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  category,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.mediumSemiBold.copyWith(
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}