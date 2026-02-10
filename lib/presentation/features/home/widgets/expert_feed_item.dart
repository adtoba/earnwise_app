import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ExpertFeedItem extends StatelessWidget {
  const ExpertFeedItem({super.key, required this.userImageUrl, required this.userName, required this.text, required this.time, this.images, required this.onTap});

  final String userImageUrl ;
  final String userName;
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: config.sw(15),
              backgroundImage: NetworkImage("https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80"),
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
                        style: TextStyles.largeSemiBold,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.favorite_border),
                      XMargin(5),
                      Text("100"),
        
                      XMargin(20),
        
                      Icon(Icons.comment_outlined, size: 20),
                      XMargin(5),
                      Text("5"),
        
                      XMargin(20),
        
                      Icon(Icons.ios_share, size: 20),
                    ],
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}