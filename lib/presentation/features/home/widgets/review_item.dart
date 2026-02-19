import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewItem extends StatelessWidget {
  const ReviewItem({super.key, required this.fullName, required this.rating, required this.comment, required this.createdAt});

  final String? fullName;
  final double? rating;
  final String? comment;
  final String? createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                fullName ?? "", 
                style: TextStyles.largeSemiBold
              )
            ),
            RatingBar.builder(
              initialRating: rating ?? 0,
              glowColor: Color(0xffFF9F29),
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 20,
              ignoreGestures: true,
              itemBuilder: (context, index) => Icon(Icons.star, color: Color(0xffFF9F29)),
              onRatingUpdate: (rating) {
                print(rating);
              },
            )
          ],
        ),
        YMargin(5),
        Text(
          timeago.format(DateTime.parse(createdAt ?? "")),
          style: TextStyles.smallRegular,
        ),
        YMargin(5),
        Text(
          comment ?? "", 
          style: TextStyles.mediumRegular
        )
      ],
    );
  }
}