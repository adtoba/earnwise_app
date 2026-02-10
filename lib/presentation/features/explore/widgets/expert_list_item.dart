import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertListItem extends StatelessWidget {
  const ExpertListItem({
    required this.name,
    required this.rating,
    required this.consultations,
    required this.location,
    required this.rate,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final double rating;
  final int consultations;
  final String location;
  final String rate;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(config.sw(14)),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.18 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                width: config.sw(100),
                height: config.sw(100),
                fit: BoxFit.cover,
              ),
            ),
            XMargin(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyles.largeBold.copyWith(
                            color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Palette.surfaceButtonLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          rate,
                          style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                        ),
                      ),
                    ],
                  ),
                  YMargin(6),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                      XMargin(4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyles.smallSemiBold.copyWith(
                          color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                        ),
                      ),
                      XMargin(8),
                      Text(
                        "($consultations consultations)",
                        style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                      ),
                    ],
                  ),
                  YMargin(6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                  ),
                  YMargin(6),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: secondaryTextColor),
                      XMargin(4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}