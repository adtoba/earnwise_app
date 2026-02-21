import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/post_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/features/home/screens/feed_info_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/expert_feed_item.dart';
import 'package:earnwise_app/presentation/features/expert/screens/new_post_screen.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExpertPostsScreen extends ConsumerStatefulWidget {
  const ExpertPostsScreen({super.key});

  @override
  ConsumerState<ExpertPostsScreen> createState() => _ExpertPostsScreenState();
}

class _ExpertPostsScreenState extends ConsumerState<ExpertPostsScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postNotifier).getMyPosts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postProvider = ref.watch(postNotifier);
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Posts",
          style: TextStyles.largeBold,
        ),
      ),
      body: Builder(
        builder: (context) {
          if(postProvider.isLoading) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: CustomProgressIndicator(),
              ),
            );
          } else if(postProvider.posts.isEmpty) {
            return Center(
              child: Text(
                "You haven't posted anything yet",
                style: TextStyles.largeBold,
              ),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: config.sw(16)),
              itemBuilder: (c, i) {
                var posts = postProvider.posts[i];
                // final images = <String>[
                //   "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                //   "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                //   "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                //   "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                // ];
                // final visibleImages = images.take(3).toList();

                final visibleImages = posts.attachments?.toList();
            
                return ExpertFeedItem(
                  location: "${posts.user?.state ?? ""}, ${posts.user?.country ?? ""}",
                  userImageUrl: posts.user?.profilePicture ?? "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80",
                  userName: "${posts.user?.firstName ?? ""} ${posts.user?.lastName ?? ""}",
                  text: posts.content ?? "",
                  likesCount: posts.likesCount ?? 0,
                  commentsCount: posts.commentsCount ?? 0,
                  time: timeago.format(DateTime.parse(posts.createdAt ?? "")),
                  images: visibleImages,
                  onMoreOptionsTap: () => postProvider.showMoreOptions(
                    context: context, 
                    postId: posts.id ?? ""
                  ),
                  onUserTap: () {
                    push(ExpertProfileScreen(expert: ExpertProfileModel(
                      id: posts.expertId,
                      user: User(
                        firstName: posts.user?.firstName,
                        lastName: posts.user?.lastName,
                        profilePicture: posts.user?.profilePicture,
                      )
                    )));
                  },
                  onTap: () {
                    push(FeedInfoScreen(post: posts));
                  },
                );
              },
              separatorBuilder: (c, i) => Divider(height: 20, color: isDarkMode ? Palette.borderDark : Palette.borderLight),
              // physics: NeverScrollableScrollPhysics(),
              itemCount: postProvider.posts.length
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(NewPostScreen());
        },
        backgroundColor: Palette.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}