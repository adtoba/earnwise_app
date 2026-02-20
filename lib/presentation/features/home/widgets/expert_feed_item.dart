import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertFeedItem extends StatelessWidget {
  const ExpertFeedItem({
    super.key, 
    required this.userImageUrl, 
    required this.userName, 
    required this.likesCount, 
    required this.commentsCount, 
    required this.text, 
    this.location,
    required this.time, 
    this.images, 
    required this.onTap
  });

  final String userImageUrl ;
  final String userName;
  final int likesCount;
  final int commentsCount;
  final String? location;
  final String text;    
  final String time;
  final List<String>? images;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: config.sw(20),
                  backgroundImage: NetworkImage(
                    userImageUrl,
                  ),
                ),
                XMargin(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.largeSemiBold,
                            ),
                          ),
                          XMargin(5),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 15,
                          ),
                        ],
                      ),
                      Text(
                        location ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.xSmallMedium,
                      ),
                    ],
                  ),
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
                Icon(Icons.more_horiz),
                YMargin(10),
              ],
            ),
            YMargin(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                if (images?.isNotEmpty ?? false)...[
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    height: config.sh(200),
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const spacing = 5.0;
                        final imageCount = images?.length ?? 0;
                        final crossAxisCount = imageCount == 1 ? 1 : 2;
                        final rows = imageCount <= 2 ? 1 : 2;
                        final totalSpacing = spacing * (crossAxisCount - 1);
                        final totalRunSpacing = spacing * (rows - 1);
                        final cellWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;
                        final cellHeight = (constraints.maxHeight - totalRunSpacing) / rows;
                        final childAspectRatio = cellWidth / cellHeight;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: imageCount,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemBuilder: (c, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              images?[i] ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                YMargin(10),
                Row(
                  children: [
                    FeedAction(
                      icon: Icons.favorite_border,
                      label: likesCount.toString(),
                      onTap: () {},
                    ),
                    XMargin(12),
                    FeedAction(
                      icon: Icons.comment_outlined,
                      label: commentsCount.toString(),
                      onTap: () {},
                    ),
                    Spacer(),
                    FeedAction(
                      icon: Icons.ios_share,
                      label: "Share",
                      onTap: () {},
                    ),
                  ],
                )
              ]
            ),
          ],
        ),
      ),
    );
  }
}

class FeedAction extends StatelessWidget {
  const FeedAction({super.key, required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20),
            XMargin(6),
            Text(
              label,
              style: TextStyles.smallSemiBold,
            ),
          ],
        ),
      ),
    );
  }
}