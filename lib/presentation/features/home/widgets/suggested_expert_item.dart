import 'package:earnwise_app/core/constants/constants.dart';
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
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        Icon(Icons.verified, color: Colors.blue, size: 15),
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