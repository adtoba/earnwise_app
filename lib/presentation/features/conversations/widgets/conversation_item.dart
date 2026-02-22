import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  const ConversationItem({super.key, required this.userImageUrl, required this.userName, required this.lastMessage, required this.lastMessageType, required this.time, required this.isVerified, required this.isRead, required this.onTap, this.isLastMessageByUser, this.isExpert});

  final String userImageUrl;
  final String userName;
  final String lastMessage;
  final String lastMessageType;
  final String time;
  final bool isVerified;
  final VoidCallback onTap;
  final bool? isLastMessageByUser;
  final bool? isExpert;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                userImageUrl,
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
                      Text(
                        userName,
                        style: TextStyles.largeSemiBold,
                      ),
                      XMargin(5),
                      Icon(Icons.verified, color: Colors.blue, size: 15),
                      XMargin(10),
                      Text(
                        time,
                        style: TextStyles.smallRegular,
                      ),
                      if(isRead == false)...[
                        Spacer(),
                        Icon(Icons.circle, color: Palette.primary, size: 10,)
                      ],
                      
                    ],
                  ),
                  YMargin(5),
                  Text(
                    isLastMessageByUser == true ? "You: $lastMessage" : "Expert: ${lastMessageType == "audio" ? "Audio Message" : lastMessageType == "video" ? "Video Message" : lastMessage}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.mediumRegular.copyWith(
                      color: isRead ? Colors.grey : (isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight),
                    ),
                  ),
                ],
              ),
            ),                  
          ],
        ),
      ),
    );
  }
}

class ExpertConversationItem extends StatelessWidget {
  const ExpertConversationItem({super.key, required this.userImageUrl, required this.userName, required this.lastMessage, required this.lastMessageType, required this.time, required this.isVerified, required this.isRead, required this.onTap, this.isLastMessageByExpert});

  final String userImageUrl;
  final String userName;
  final String lastMessage;
  final String time;
  final bool isVerified;
  final String lastMessageType;
  final VoidCallback onTap;
  final bool? isLastMessageByExpert;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                userImageUrl,
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
                      Text(
                        userName,
                        style: TextStyles.largeSemiBold,
                      ),
                      XMargin(5),
                      Icon(Icons.verified, color: Colors.blue, size: 15),
                      XMargin(10),
                      Text(
                        time,
                        style: TextStyles.smallRegular,
                      ),
                      if(isRead == false)...[
                        Spacer(),
                        Icon(Icons.circle, color: Palette.primary, size: 10,)
                      ],
                      
                    ],
                  ),
                  YMargin(5),
                  Text(
                    isLastMessageByExpert == true ? "You: ${lastMessageType == "audio" ? "Audio Message" : lastMessageType == "video" ? "Video Message" : lastMessage}" : lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.mediumRegular.copyWith(
                      color: isRead ? Colors.grey : (isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight),
                    ),
                  ),
                ],
              ),
            ),                  
          ],
        ),
      ),
    );
  }
}