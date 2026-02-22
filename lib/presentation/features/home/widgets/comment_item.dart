import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key, 
    required this.userImageUrl, 
    required this.userName, 
    required this.text, 
    required this.time, 
    this.location, 
    required this.likesCount
  });

  final String userImageUrl;
  final String userName;
  final String text;
  final String time;
  final String? location;
  final int likesCount;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: config.sw(20),
          backgroundImage: NetworkImage(userImageUrl),
        ),
        XMargin(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: TextStyles.mediumSemiBold,
                  ),
                  XMargin(5),
                  Icon(
                    Icons.verified, 
                    color: Colors.blue,
                    size: 15,
                  ),
                  XMargin(10),
                  Text(
                    time,
                    style: TextStyles.smallRegular.copyWith(
                      fontFamily: TextStyles.fontFamily,
                      color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                    ),
                  ),
                  XMargin(10),
                  Spacer(),
                  Icon(Icons.more_horiz)
                ],
              ),
              Text(
                text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.mediumRegular.copyWith(
                  fontFamily: TextStyles.fontFamily,
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border),
                  XMargin(5),
                  Text(likesCount.toString()),
                ],
              )
            ]
          ),
        ),
      ],
    );
  }
}