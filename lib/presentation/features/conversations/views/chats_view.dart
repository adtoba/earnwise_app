import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/chat_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/expert_chat_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/widgets/conversation_item.dart';
import 'package:flutter/material.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
      itemBuilder: (c, i) {
        return ConversationItem(
          userImageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80", 
          userName: i % 2 == 0 ? "Habib Adebisi" : "John Doe", 
          lastMessage: "My name is John Doe. I am a software engineer and I am looking for a job.", 
          time: "12:00 PM", 
          isVerified: true, 
          isRead: i % 2 == 0 ? false : true,
          onTap: () {
            push(ChatScreen());
          }
        );
      },
      separatorBuilder: (c, i) => YMargin(25),
      itemCount: 5,
      shrinkWrap: true,
    );
  }
}