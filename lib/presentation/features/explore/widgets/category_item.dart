import 'package:earnwise_app/core/constants/constants.dart';
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(12), vertical: config.sh(10)),
        decoration: BoxDecoration(
          color: isDarkMode ? Palette.surfaceButtonDark : Palette.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Palette.borderDark : Palette.borderLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Hero(
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
            ),
          ],
        ),
      ),
    );
  }
}