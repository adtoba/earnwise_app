import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/all_reviews_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/review_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ReviewsView extends StatelessWidget {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Reviews (100)",
                  maxLines: 1,
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.h4Bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  push(const AllReviewsScreen());
                }, 
                child: Text(
                  "View all", 
                  style: TextStyles.mediumMedium.copyWith(
                    fontFamily: TextStyles.fontFamily,
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  )
                )
              )
            ],
          ),
          YMargin(10),
          ListView.separated(
            itemBuilder: (c, i) {
              return ReviewItem();
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (c, i) => Divider(height: config.sh(20), color: isDarkMode ? Palette.borderDark : Palette.borderLight), 
            itemCount: 4
          ),
        ],
      ),
    );
  }
}