import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/navigator.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/features/conversations/screens/expert_chat_screen.dart';
import 'package:earnwise_app/presentation/features/conversations/widgets/conversation_item.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

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
                ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
                  itemBuilder: (c, i) {
                    return ConversationItem(
                      userImageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80", 
                      userName: i % 2 == 0 ? "Habib Adebisi" : "John Doe", 
                      lastMessage: "My name is John Doe. I am a software engineer and I am looking for a job.", 
                      time: "12:00 PM", 
                      isVerified: true, 
                      isRead: false,
                      onTap: () {
                        push(ExpertChatScreen());
                      }
                    );
                  },
                  separatorBuilder: (c, i) => YMargin(25),
                  itemCount: 5,
                  shrinkWrap: true,
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(20)),
                  itemBuilder: (c, i) {
                    return ConversationItem(
                      userImageUrl: "https://img.freepik.com/free-photo/portrait-confident-young-businessman-with-his-arms-crossed_23-2148176206.jpg?semt=ais_hybrid&w=740&q=80", 
                      userName: i % 2 == 0 ? "Habib Adebisi" : "John Doe", 
                      lastMessage: "My name is John Doe. I am a software engineer and I am looking for a job.", 
                      time: "12:00 PM", 
                      isVerified: true, 
                      isRead: true,
                      onTap: () {
                        push(ExpertChatScreen());
                      }
                    );
                  },
                  separatorBuilder: (c, i) => YMargin(25),
                  itemCount: 5,
                  shrinkWrap: true,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}