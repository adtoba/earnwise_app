import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/widgets/comment_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';

class FeedInfoScreen extends StatefulWidget {
  const FeedInfoScreen({super.key, this.images});
  
  final List<String>? images;

  @override
  State<FeedInfoScreen> createState() => _FeedInfoScreenState();
}

class _FeedInfoScreenState extends State<FeedInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Feed"
        )
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: config.sw(20),
                    backgroundImage: NetworkImage("https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80"),
                  ),
                  XMargin(10),
                  Text(
                    "Albert Einstein",
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
                    "2h",
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
              YMargin(10),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              ),
              YMargin(10),
              if (widget.images?.isNotEmpty ?? false)
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
                      final imageCount = widget.images?.length ?? 0;
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
                            widget.images?[i] ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              YMargin(20),
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
              ),
              YMargin(10),
              Divider(
                height: 20,
                color: isDarkMode ? Palette.borderDark : Palette.borderLight,
              ),
              Text(
                "Comments (5)",
                style: TextStyles.largeBold
              ),
              YMargin(20),
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: config.sw(10)),
                itemBuilder: (c, i) => CommentItem(
                  userImageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                  userName: "Albert Einstein",
                  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  time: "2h",
                ),
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (c, i) => Divider(height: 20, color: isDarkMode ? Palette.borderDark : Palette.borderLight),
                itemCount: 5
              )
            ],
          ),
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: config.sw(20),
            right: config.sw(20),
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: config.sh(10),
          ),
          child: SearchTextField(
            hint: "Add a comment",
          ),
        ),
      ),
    );
  }
}