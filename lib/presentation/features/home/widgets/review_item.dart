import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Blessing Grace", 
                style: TextStyles.largeSemiBold
              )
            ),
            RatingBar.builder(
              initialRating: 4.5,
              glowColor: Color(0xffFF9F29),
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              itemBuilder: (context, index) => Icon(Icons.star, color: Color(0xffFF9F29)),
              onRatingUpdate: (rating) {
                print(rating);
              },
            )
          ],
        ),
        YMargin(5),
        Text(
          "2 days ago",
          style: TextStyles.smallRegular,
        ),
        YMargin(5),
        Text(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 
          style: TextStyles.mediumRegular
        )
      ],
    );
  }
}