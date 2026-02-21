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
    required this.onTap,
    required this.onUserTap,
    required this.onMoreOptionsTap,
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
  final VoidCallback onUserTap;
  final VoidCallback onMoreOptionsTap;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightBackground;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        padding: EdgeInsets.all(config.sw(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onUserTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: config.sw(22),
                    backgroundColor: Palette.primary.withOpacity(0.12),
                    child: CircleAvatar(
                      radius: config.sw(20),
                      backgroundImage: NetworkImage(userImageUrl),
                    ),
                  ),
                  XMargin(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.largeSemiBold.copyWith(
                                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                                ),
                              ),
                            ),
                            XMargin(6),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: config.sw(6), vertical: config.sh(2)),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.verified, color: Colors.blue, size: 12),
                                  XMargin(4),
                                  Text(
                                    "Verified",
                                    style: TextStyles.xSmallMedium.copyWith(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        YMargin(2),
                        Text(
                          location ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.xSmallMedium.copyWith(color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  XMargin(8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        time,
                        style: TextStyles.xSmallMedium.copyWith(color: secondaryTextColor),
                      ),
                      YMargin(6),
                      InkWell(
                        onTap: onMoreOptionsTap,
                        child: Icon(
                          Icons.more_horiz, 
                          color: secondaryTextColor
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            YMargin(12),
            Text(
              text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.mediumRegular.copyWith(
                fontFamily: TextStyles.fontFamily,
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
            ),
            if (images?.isNotEmpty ?? false) ...[
              YMargin(12),
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(10),
                height: config.sh(210),
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 6.0;
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
                        borderRadius: BorderRadius.circular(12),
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
            YMargin(12),
            Row(
              children: [
                FeedAction(
                  icon: Icons.favorite_border,
                  label: likesCount.toString(),
                  onTap: () {},
                ),
                XMargin(10),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 18, color: textColor),
            XMargin(6),
            Text(
              label,
              style: TextStyles.smallSemiBold.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}