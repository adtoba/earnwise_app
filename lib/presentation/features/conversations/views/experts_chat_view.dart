import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/chat_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/chat_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/expert_chat_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/widgets/conversation_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExpertsChatsView extends StatelessWidget {
  const ExpertsChatsView({super.key});

  @override
  Widget build(BuildContext context) {

    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          YMargin(30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: config.sw(20)),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode ? Palette.darkFillColor : Palette.lightFillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: isDarkMode ? Palette.lightFillColor : Palette.darkFillColor,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: isDarkMode ? Palette.textGeneralLight : Palette.textGeneralDark,
              unselectedLabelColor: isDarkMode ? Palette.textGeneralDark.withOpacity(0.7) : Palette.textGeneralLight.withOpacity(0.7),
              labelStyle: TextStyles.mediumSemiBold,
              tabs: const [
                Tab(text: "Pending"),
                Tab(text: "Complete"),
              ],
            ),
          ),
          YMargin(10),
          Expanded(
            child: TabBarView(
              children: [
                PendingChatsView(),
                CompletedChatsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PendingChatsView extends ConsumerStatefulWidget {
  const PendingChatsView({super.key});

  @override
  ConsumerState<PendingChatsView> createState() => _PendingChatsViewState();
}

class _PendingChatsViewState extends ConsumerState<PendingChatsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifier).getExpertChats();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatNotifier);
    var chats = chatProvider.expertChats;
    var isLoading = chatProvider.isLoading;

    if (isLoading && chats.isEmpty) {
      return Center(
        child: CustomProgressIndicator(),
      );
    } else if (chats.isEmpty) {
      return Center(
        child: Text("No conversations yet"),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
        itemBuilder: (c, i) {
          var chat = chats[i];
          return ExpertConversationItem(
            userImageUrl: chat.user?.profilePicture ?? "", 
            userName: "${chat.user?.firstName ?? ""} ${chat.user?.lastName ?? ""}", 
            lastMessage: chat.lastMessage?.content ?? "", 
            lastMessageType: chat.lastMessage?.contentType ?? "",
            time: timeago.format(DateTime.parse(chat.createdAt ?? "")),
            isLastMessageByExpert: chat.lastMessage?.senderId == chat.expertId,
            isVerified: true, 
            isRead: false,
            onTap: () {
              push(ExpertChatScreen(
                chat: chat,
              ));
            }
          );
        },
        separatorBuilder: (c, i) => YMargin(25),
        itemCount: chats.length,
        shrinkWrap: true,
      );
    }
  }
}


class CompletedChatsView extends ConsumerStatefulWidget {
  const CompletedChatsView({super.key});

  @override
  ConsumerState<CompletedChatsView> createState() => _CompletedChatsViewState();
}

class _CompletedChatsViewState extends ConsumerState<CompletedChatsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifier).getExpertChats();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatNotifier);
    var chats = chatProvider.expertChats;
    var isLoading = chatProvider.isLoading;

    if (isLoading && chats.isEmpty) {
      return Center(
        child: CustomProgressIndicator(),
      );
    } else if (chats.isEmpty) {
      return Center(
        child: Text("No conversations yet"),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
        itemBuilder: (c, i) {
          var chat = chats[i];
          return ExpertConversationItem(
            userImageUrl: chat.user?.profilePicture ?? "", 
            userName: "${chat.user?.firstName ?? ""} ${chat.user?.lastName ?? ""}", 
            lastMessage: chat.lastMessage?.content ?? "", 
            lastMessageType: chat.lastMessage?.contentType ?? "",
            time: timeago.format(DateTime.parse(chat.createdAt ?? "")), 
            isLastMessageByExpert: chat.lastMessage?.senderId == chat.expertId,
            isVerified: true, 
            isRead: false,
            onTap: () {
              push(ExpertChatScreen(
                chat: chat,
              ));
            }
          );
        },
        separatorBuilder: (c, i) => YMargin(25),
        itemCount: chats.length,
        shrinkWrap: true,
      );
    }
  }
}