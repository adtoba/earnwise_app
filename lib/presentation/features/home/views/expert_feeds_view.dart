import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/feed_info_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/expert_feed_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertFeedsView extends StatelessWidget {
  const ExpertFeedsView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Expert Posts",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.xLargeSemiBold.copyWith(
                    fontFamily: TextStyles.fontFamily,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {}, 
                child: Text(
                  "See All", 
                  style: TextStyles.mediumMedium.copyWith(
                    fontFamily: TextStyles.fontFamily,
                    color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                  )
                )
              )
            ],
          ),
        ),
        YMargin(10),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
          itemBuilder: (c, i) {
            final images = <String>[
              "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
              "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
              "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
              "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
            ];
            final visibleImages = images.take(3).toList();

            return ExpertFeedItem(
              userImageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
              userName: "Albert Einstein",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              time: "2h",
              images: i % 2 == 0 ? visibleImages : [],
              onTap: () {
                push(FeedInfoScreen(images: visibleImages));
              },
            );
          },
          separatorBuilder: (c, i) => Divider(height: 20, color: isDarkMode ? Palette.borderDark : Palette.borderLight),
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5
        ),
      ],
    );
  }
}