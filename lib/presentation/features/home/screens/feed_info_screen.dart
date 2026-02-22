import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/post_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/post_model.dart';
import 'package:earnwise_app/presentation/features/home/screens/expert_profile_screen.dart';
import 'package:earnwise_app/presentation/features/home/widgets/comment_item.dart';
import 'package:earnwise_app/presentation/features/home/widgets/expert_feed_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:earnwise_app/presentation/widgets/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedInfoScreen extends ConsumerStatefulWidget {
  const FeedInfoScreen({super.key, this.post});
  
  final PostModel? post;

  @override
  ConsumerState<FeedInfoScreen> createState() => _FeedInfoScreenState();
}

class _FeedInfoScreenState extends ConsumerState<FeedInfoScreen> {

  final commentController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postNotifier).getPostComments(postId: widget.post?.id ?? "");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var postProvider = ref.watch(postNotifier);
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "Post"
        )
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  push(ExpertProfileScreen(expert: ExpertProfileModel(
                    id: widget.post?.expertId ?? "",
                    user: User(
                      firstName: widget.post?.user?.firstName,
                      lastName: widget.post?.user?.lastName,
                      profilePicture: widget.post?.user?.profilePicture,
                    )
                  )));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: config.sw(20),
                      backgroundImage: NetworkImage(
                        widget.post?.user?.profilePicture == "" 
                          ? "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80"
                          : widget.post?.user?.profilePicture ?? ""
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
                                  "${widget.post?.user?.firstName ?? ""} ${widget.post?.user?.lastName ?? ""}",
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
                            "${widget.post?.user?.state ?? ""}, ${widget.post?.user?.country ?? ""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.xSmallMedium,
                          ),
                        ],
                      ),
                    ),
                    XMargin(10),
                    Text(
                      timeago.format(DateTime.parse(widget.post?.createdAt ?? "")),
                      style: TextStyles.smallRegular.copyWith(
                        fontFamily: TextStyles.fontFamily,
                        color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                      ),
                    ),
                    XMargin(10),
                    InkWell(
                      onTap: () {
                        postProvider.showMoreOptions(
                          context: context, 
                          postId: widget.post?.id ?? ""
                        );
                      },
                      child: Icon(Icons.more_horiz)
                    ),
                    YMargin(10),
                  ],
                ),
              ),
              YMargin(10),
              Text(
                widget.post?.content ?? "",
                style: TextStyles.mediumRegular,
              ),
              YMargin(10),
              if (widget.post?.attachments?.isNotEmpty ?? false)
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
                      final imageCount = widget.post?.attachments?.length ?? 0;
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
                            widget.post?.attachments?[i] ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              YMargin(20),
              Row(
                children: [
                  FeedAction(
                    icon: Icons.favorite_border,
                    label: widget.post?.likesCount?.toString() ?? "0",
                    onTap: () {},
                  ),
                  XMargin(12),
                  FeedAction(
                    icon: Icons.comment_outlined,
                    label: widget.post?.commentsCount?.toString() ?? "0",
                    onTap: () {},
                  ),
                  Spacer(),
                  FeedAction(
                    icon: Icons.ios_share,
                    label: "Share",
                    onTap: () {},
                  ),
                ],
              ),
              YMargin(10),
              Divider(
                height: 20,
                color: isDarkMode ? Palette.borderDark : Palette.borderLight,
              ),
              Text(
                "Comments (${ref.watch(postNotifier).comments.length})",
                style: TextStyles.largeBold
              ),
              YMargin(20),
              if(ref.watch(postNotifier).isPostCommentsLoading)...[
                Center(
                  child: CustomProgressIndicator(),
                )
              ] else if(ref.watch(postNotifier).comments.isEmpty)...[
                Center(
                  child: Text("No comments yet"),
                )
              ] else ...[
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (c, i) {
                    var comment = ref.watch(postNotifier).comments[i];

                    return CommentItem(
                      userImageUrl: comment.user?.profilePicture ?? "",
                      userName: "${comment.user?.firstName ?? ""} ${comment.user?.lastName ?? ""}",
                      text: comment.comment ?? "",
                      time: timeago.format(DateTime.parse(comment.createdAt ?? "")),
                      likesCount: comment.likesCount ?? 0,
                      location: "${comment.user?.state ?? ""}, ${comment.user?.country ?? ""}",
                    );
                  },
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (c, i) => Divider(
                    height: 20, 
                    color: isDarkMode ? Palette.borderDark : Palette.borderLight
                  ),
                  itemCount: ref.watch(postNotifier).comments.length
                )
              ]
            ],
          ),
        )
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: config.sw(20),
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: config.sh(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: SearchTextField(
                  controller: commentController,
                  hint: "Add a comment",
                ),
              ),
              XMargin(10),
              IconButton(
                onPressed: () {
                  if(commentController.text.isNotEmpty) {
                    String comment = commentController.text.trim();
                    commentController.clear();

                    ref.read(postNotifier).commentOnPost(
                      postId: widget.post?.id ?? "", 
                      comment: comment
                    );
                  }
                  
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}