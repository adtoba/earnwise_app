import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/chat_provider.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/chat_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/widgets/conversation_item.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatsView extends ConsumerStatefulWidget {
  const ChatsView({super.key});

  @override
  ConsumerState<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends ConsumerState<ChatsView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatNotifier).getUserChats();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatNotifier);
    var chats = chatProvider.chats;
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
          return ConversationItem(
            userImageUrl: chat.expert?.user?.profilePicture ?? "", 
            userName: "${chat.expert?.user?.firstName ?? ""} ${chat.expert?.user?.lastName ?? ""}", 
            lastMessage: chat.lastMessage?.content ?? "", 
            lastMessageType: chat.lastMessage?.contentType ?? "",
            isLastMessageByUser: chat.lastMessage?.senderId == chat.userId,
            time: timeago.format(DateTime.parse(chat.lastMessage?.createdAt ?? "")), 
            isVerified: true, 
            isRead: false,
            onTap: () {
              push(ChatScreen(
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