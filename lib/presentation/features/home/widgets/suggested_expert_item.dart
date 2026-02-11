import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class SuggestedExpertItem extends StatelessWidget {
  const SuggestedExpertItem({super.key, required this.imageUrl, required this.name, required this.title, required this.onTap});

  final String imageUrl;
  final String name;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: config.sw(2), vertical: config.sh(2)),
        decoration: BoxDecoration(
          color: isDarkMode ? Palette.darkFillColor : Palette.lightBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Palette.borderDark : Palette.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.18 : 0.08),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: config.sw(150),
                height: config.sh(200),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: config.sw(10), vertical: config.sh(8)),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: config.sw(8), vertical: config.sh(3)),
                          decoration: BoxDecoration(
                            color: Palette.primary.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Top Expert",
                            style: TextStyles.xSmallSemiBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: config.sw(6), vertical: config.sh(2)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber.shade400, size: 12),
                              XMargin(4),
                              Text(
                                "4.9",
                                style: TextStyles.xSmallSemiBold.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    YMargin(6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name, 
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.mediumSemiBold.copyWith(
                              fontFamily: TextStyles.fontFamily,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        XMargin(6),
                        Icon(Icons.verified, color: Colors.lightBlueAccent, size: 14),
                      ],
                    ),
                    Text(
                      title, 
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.smallRegular.copyWith(
                        fontFamily: TextStyles.fontFamily,
                        color: Colors.white,
                      ),
                    ),
                    // YMargin(6),
                    // Row(
                    //   children: [
                    //     Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                    //     XMargin(4),
                    //     Expanded(
                    //       child: Text(
                    //         "Lagos, Nigeria",
                    //         maxLines: 1,
                    //         overflow: TextOverflow.ellipsis,
                    //         style: TextStyles.xSmallRegular.copyWith(color: Colors.white70),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: config.sh(8),
              right: config.sw(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: config.sw(8), vertical: config.sh(4)),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 12, color: Colors.white),
                    XMargin(4),
                    Text(
                      "\$30 / text",
                      style: TextStyles.xSmallSemiBold.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}