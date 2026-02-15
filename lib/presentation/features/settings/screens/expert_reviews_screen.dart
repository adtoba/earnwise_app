import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/widgets/review_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExpertReviewsScreen extends StatefulWidget {
  const ExpertReviewsScreen({super.key});

  @override
  State<ExpertReviewsScreen> createState() => _ExpertReviewsScreenState();
}

class _ExpertReviewsScreenState extends State<ExpertReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Reviews",
          style: TextStyles.largeBold
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1,
                    color: isDarkMode ? Colors.grey : Colors.grey,
                  )
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "4.5",
                                  style: TextStyles.h3Bold.copyWith(
                                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                                  )
                                ),
                                TextSpan(
                                  text: " /5",
                                  style: TextStyles.mediumMedium.copyWith(
                                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                                  )
                                )
                              ],
                            ),
                          ),
                          YMargin(10),
                          Text(
                            "100 Rating(s)",
                            style: TextStyles.smallRegular.copyWith(
                              fontSize: config.sp(12),
                              color: Colors.grey,
                            )
                          ),
                        ],
                      ),
                    ),
                    RatingBar(
                      itemSize: 25,
                      glowRadius: 10,
                      initialRating: 4.0,
                      unratedColor: Colors.grey,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Palette.ratingStar,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Palette.ratingStar,
                        ),
                        empty: Icon(
                          Icons.star_outline,
                          color: Palette.ratingStar,
                        ),
                      ),
                      onRatingUpdate: (rating) {},
                    )
                  ],
                ),
              ),
              YMargin(20),
              Text(
                "User Reviews",
                style: TextStyles.largeBold.copyWith(
                  color: isDarkMode ? Colors.grey : Colors.black,
                ),
              ),
              Divider(height: config.sh(20), color: isDarkMode ? Palette.borderDark : Palette.borderLight),
              YMargin(20),
              ListView.separated(
                itemBuilder: (c, i) {
                  return ReviewItem();
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (c, i) => Divider(height: config.sh(20), color: isDarkMode ? Palette.borderDark : Palette.borderLight), 
                itemCount: 10
              ),
            ],
          ),
        ),
      ),
    );
  }
}