import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/post_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/home/screens/feed_info_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/expert_feed_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExpertFeedsView extends ConsumerStatefulWidget {
  const ExpertFeedsView({super.key});

  @override
  ConsumerState<ExpertFeedsView> createState() => _ExpertFeedsViewState();
}

class _ExpertFeedsViewState extends ConsumerState<ExpertFeedsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postNotifier).getRecommendedPosts();
    });
  }
  @override
  Widget build(BuildContext context) {
    var postProvider = ref.watch(postNotifier);
    var recommendedPosts = postProvider.recommendedPosts;
    var isRecommendedPostsLoading = postProvider.isRecommendedPostsLoading;
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
                  style: TextStyles.largeBold
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
        if (isRecommendedPostsLoading && recommendedPosts.isEmpty) ...[
          Center(
            child: CustomProgressIndicator(),
          )
        ] else if (recommendedPosts.isEmpty) ...[
          Center(
            child: Text("No recommended posts found"),
          )
        ] else ...[
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
            itemBuilder: (c, i) {
              var post = recommendedPosts[i];

              return ExpertFeedItem(
                userImageUrl: post.user?.profilePicture != "" ? post.user?.profilePicture ?? "" : "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                userName: "${post.user?.firstName ?? ""} ${post.user?.lastName ?? ""}",
                text: post.content ?? "",
                time: timeago.format(DateTime.parse(post.createdAt ?? "")),
                likesCount: post.likesCount ?? 0,
                commentsCount: post.commentsCount ?? 0,
                images: post.attachments?.toList(),
                onTap: () {
                  push(FeedInfoScreen(post: post));
                },
              );
            },
            separatorBuilder: (c, i) => Divider(height: 20, color: isDarkMode ? Palette.borderDark : Palette.borderLight),
            physics: NeverScrollableScrollPhysics(),
            itemCount: recommendedPosts.length
          ),
        ]
      ],
    );
  }
}