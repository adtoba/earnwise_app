import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/review_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/all_reviews_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/review_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewsView extends ConsumerStatefulWidget {
  const ReviewsView({super.key, required this.expertId});

  final String expertId;

  @override
  ConsumerState<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends ConsumerState<ReviewsView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewNotifier).getExpertReviews(expertId: widget.expertId);
    });
    super.initState(); 
  }

  @override
  Widget build(BuildContext context) {
    var reviewProvider = ref.watch(reviewNotifier);
    var isExpertReviewsLoading = reviewProvider.isExpertReviewsLoading;
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
                  "Reviews",
                  maxLines: 1,
                  textScaler: TextScaler.noScaling,
                  style: TextStyles.h4Bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  push(AllReviewsScreen(
                    reviews: reviewProvider.expertReviews,
                  ));
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
          if (isExpertReviewsLoading) ...[
            Center(
              child: CustomProgressIndicator(),
            )
          ] else if (reviewProvider.expertReviews.isEmpty) ...[
            Center(
              child: Text("No reviews yet"),
            )
          ] else ...[
            ListView.separated(
              itemBuilder: (c, i) {
                var review = reviewProvider.expertReviews[i];
                return ReviewItem(
                  fullName: review.fullName ?? "",
                  rating: review.rating ?? 0,
                  comment: review.comment ?? "",
                  createdAt: review.createdAt ?? "",
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (c, i) => Divider(
                height: config.sh(20), 
                color: isDarkMode ? Palette.borderDark : Palette.borderLight
              ), 
              itemCount: reviewProvider.expertReviews.take(5).length
            ),
          ]
        ],
      ),
    );
  }
}