import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/chat_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/models/chat_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ExpertChatScreen extends ConsumerStatefulWidget {
  const ExpertChatScreen({super.key, this.chat});

  final ChatModel? chat;  

  @override
  ConsumerState<ExpertChatScreen> createState() => _ExpertChatScreenState();
}

enum ExpertAnswerType { text, audio, video }

class _ExpertChatScreenState extends ConsumerState<ExpertChatScreen> {
  final _messageController = TextEditingController();
  ExpertAnswerType _selectedType = ExpertAnswerType.text;
  int? _activeReplyIndex;

  final List<_ExpertConversationItem> _items = [
    _ExpertConversationItem(
      question: "Hi, can you review my budget plan for Q2?",
      requestedType: ExpertAnswerType.video,
      time: "10:22 AM",
      response: _ExpertResponse(
        type: ExpertAnswerType.video,
        text: "Video response available",
        time: "10:30 AM",
      ),
    ),
    _ExpertConversationItem(
      question: "Thanks! Can you also advise on saving for taxes?",
      requestedType: ExpertAnswerType.audio,
      time: "10:35 AM",
      response: _ExpertResponse(
        type: ExpertAnswerType.audio,
        text: "Audio response available",
        time: "10:44 AM",
      ),
    ),
    _ExpertConversationItem(
      question: "Can you summarize the key risks in my plan?",
      requestedType: ExpertAnswerType.text,
      time: "11:02 AM",
      response: null,
    ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(chatNotifier).getChatMessages(widget.chat?.id ?? "");
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var chatProvider = ref.watch(chatNotifier);
    var expert = widget.chat?.expert;
    var messages = chatProvider.messages;
    var user = widget.chat?.user;
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Palette.darkBackground : Palette.lightBackground;
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${user?.firstName ?? ""} ${user?.lastName ?? ""}",
                style: TextStyles.largeBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              Text(
                "Last active 2h ago",
                style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: chatProvider.isMessagesLoading 
                ? Center(child: CustomProgressIndicator()) 
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _ExpertConversationCard(
                        message: message,
                        isDarkMode: isDarkMode,
                        user: user,
                        isUser: message.senderId == widget.chat?.user?.id,
                        isActive: _activeReplyIndex == index,
                        onReply: () {
                          setState(() {
                            _selectedType = message.responseType == "audio" ? ExpertAnswerType.audio : message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text;
                            _activeReplyIndex = index;
                          });
                        },
                      );
                    },
                    separatorBuilder: (_, __) => YMargin(12),
                    itemCount: messages.length,
                  ),
            ),
            if(_activeReplyIndex != null)...[
              Container(
                padding: EdgeInsets.fromLTRB(
                  config.sw(16),
                  config.sh(12),
                  config.sw(16),
                  config.sh(8),
                ),
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode ? Palette.borderDark : Palette.borderLight,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _ExpertAnswerTypeSelector(
                      selectedType: _selectedType,
                      isDarkMode: isDarkMode,
                      onChanged: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                    YMargin(10),
                    _buildComposer(
                      isDarkMode: isDarkMode,
                      secondaryTextColor: secondaryTextColor,
                    ),
                    YMargin(10),
                  ],
                ),
              ),
            ],
            
          ],
        ),
      ),
    );
  }

  Widget _buildComposer({
    required bool isDarkMode,
    required Color secondaryTextColor,
  }) {
    if (_selectedType == ExpertAnswerType.audio) {
      return _AudioComposer(
        isDarkMode: isDarkMode,
        onSend: () {},
      );
    }

    if (_selectedType == ExpertAnswerType.video) {
      return _VideoComposer(
        isDarkMode: isDarkMode,
        onSend: () {},
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            minLines: 1,
            maxLines: 4,
            style: TextStyles.mediumRegular.copyWith(
              color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
            ),
            decoration: InputDecoration(
              hintText: "Type your response...",
              hintStyle: TextStyles.mediumRegular.copyWith(color: secondaryTextColor),
              filled: true,
              fillColor: isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight,
              contentPadding: EdgeInsets.symmetric(
                horizontal: config.sw(14),
                vertical: config.sh(12),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        XMargin(10),
        ElevatedButton(
          onPressed: () {
            if(_messageController.text.isNotEmpty) {
              ref.read(chatNotifier).sendMessage(
                chatId: widget.chat?.id ?? "",
                receiverId: widget.chat?.user?.id ?? "",
                content: _messageController.text,
                responseType: _selectedType.name,
                senderId: widget.chat?.expertId ?? "",
                senderType: "expert",
                attachments: [],
              );
              setState(() {
                _messageController.clear();
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: EdgeInsets.symmetric(
              horizontal: config.sw(16),
              vertical: config.sh(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.send, size: 18),
              YMargin(2),
              Text(
                "Send",
                style: TextStyles.smallSemiBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AudioComposer extends StatelessWidget {
  const _AudioComposer({
    required this.isDarkMode,
    required this.onSend,
  });

  final bool isDarkMode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;
    final textColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.mic, color: Palette.primary),
                XMargin(8),
                Expanded(
                  child: Text(
                    "Tap to record audio response",
                    style: TextStyles.mediumRegular.copyWith(color: textColor),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Palette.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "00:00",
                    style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
        XMargin(10),
        ElevatedButton(
          onPressed: onSend,
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: EdgeInsets.symmetric(
              horizontal: config.sw(16),
              vertical: config.sh(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.send, size: 18),
              YMargin(2),
              Text(
                "Send",
                style: TextStyles.smallSemiBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoComposer extends StatelessWidget {
  const _VideoComposer({
    required this.isDarkMode,
    required this.onSend,
  });

  final bool isDarkMode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;
    final textColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.videocam, color: Palette.primary),
                XMargin(8),
                Expanded(
                  child: Text(
                    "Record or upload a video response",
                    style: TextStyles.mediumRegular.copyWith(color: textColor),
                  ),
                ),
                Icon(Icons.attach_file, color: textColor),
              ],
            ),
          ),
        ),
        XMargin(10),
        ElevatedButton(
          onPressed: onSend,
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: EdgeInsets.symmetric(
              horizontal: config.sw(16),
              vertical: config.sh(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.send, size: 18),
              YMargin(2),
              Text(
                "Send",
                style: TextStyles.smallSemiBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExpertAnswerTypeSelector extends StatelessWidget {
  const _ExpertAnswerTypeSelector({
    required this.selectedType,
    required this.onChanged,
    required this.isDarkMode,
  });

  final ExpertAnswerType selectedType;
  final ValueChanged<ExpertAnswerType> onChanged;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final selectedColor = Palette.primary;
    final unselectedColor = isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;
    final unselectedText = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;

    Widget buildChip({
      required ExpertAnswerType type,
      required String label,
      required IconData icon,
    }) {
      final isSelected = selectedType == type;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(type),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: config.sh(10)),
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : unselectedColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? selectedColor : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : unselectedText,
                ),
                XMargin(6),
                Text(
                  label,
                  style: TextStyles.smallSemiBold.copyWith(
                    color: isSelected ? Colors.white : unselectedText,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        buildChip(type: ExpertAnswerType.text, label: "Text", icon: Icons.chat_bubble_outline),
        XMargin(8),
        buildChip(type: ExpertAnswerType.audio, label: "Audio", icon: Icons.mic_none),
        XMargin(8),
        buildChip(type: ExpertAnswerType.video, label: "Video", icon: Icons.videocam_outlined),
      ],
    );
  }
}

class _ExpertConversationCard extends StatelessWidget {
  const _ExpertConversationCard({
    required this.message,
    required this.isDarkMode,
    required this.isActive,
    required this.onReply,
    required this.isUser,
    required this.user,
  });

  final MessageModel message;
  final bool isDarkMode;
  final bool isActive;
  final bool isUser;
  final User? user;
  final VoidCallback onReply; 

  @override
  Widget build(BuildContext context) {
    final questionBubbleColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final questionTextColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    final responseBubbleColor = Palette.primary;
    final responseTextColor = Colors.white;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final highlightBorderColor = isDarkMode ? Palette.primary.withOpacity(0.8) : Palette.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isUser)...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: config.sw(16),
                backgroundColor: Palette.primary.withOpacity(0.2),
                backgroundImage: user?.profilePicture != "" ? NetworkImage(user?.profilePicture ?? "") : null,
              ),
              XMargin(8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
                  decoration: BoxDecoration(
                    color: questionBubbleColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive ? Border.all(color: highlightBorderColor, width: 1.4) : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: highlightBorderColor.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _typeIcon(message.responseType == "audio" ? ExpertAnswerType.audio : message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text),
                            size: 14,
                            color: questionTextColor,
                          ),
                          XMargin(6),
                          Text(
                            "${_typeLabel(message.responseType == "audio" ? ExpertAnswerType.audio : message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text)} requested",
                            style: TextStyles.smallSemiBold.copyWith(color: questionTextColor),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: onReply,
                            style: TextButton.styleFrom(
                              foregroundColor: Palette.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                            ),
                            child: Text(
                              "Reply",
                              style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                            ),
                          ),
                        ],
                      ),
                      YMargin(6),
                      Text(
                        message.content ?? "",
                        style: TextStyles.mediumMedium.copyWith(color: questionTextColor),
                      ),
                      YMargin(6),
                      Text(
                        timeago.format(DateTime.parse(message.createdAt ?? "")),
                        style: TextStyles.xSmallRegular.copyWith(color: secondaryTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
                    decoration: BoxDecoration(
                      color: responseBubbleColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _typeIcon(message.responseType == "audio" ? ExpertAnswerType.audio : message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text),
                              size: 14,
                              color: responseTextColor,
                            ),
                            XMargin(6),
                            Text(
                              _typeLabel(message.responseType == "audio" ? ExpertAnswerType.audio : message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text),
                              style: TextStyles.smallSemiBold.copyWith(color: responseTextColor),
                            ),
                          ],
                        ),
                        YMargin(6),
                        Text(
                          message.content ?? "",
                          style: TextStyles.mediumRegular.copyWith(color: responseTextColor),
                        ),
                        YMargin(6),
                        Text(
                          timeago.format(DateTime.parse(message.createdAt ?? "")),
                          style: TextStyles.xSmallRegular.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],

      ],
    );
  }

  IconData _typeIcon(ExpertAnswerType type) {
    switch (type) {
      case ExpertAnswerType.audio:
        return Icons.graphic_eq;
      case ExpertAnswerType.video:
        return Icons.videocam;
      case ExpertAnswerType.text:
        return Icons.chat_bubble;
    }
  }

  String _typeLabel(ExpertAnswerType type) {
    switch (type) {
      case ExpertAnswerType.audio:
        return "Audio reply";
      case ExpertAnswerType.video:
        return "Video reply";
      case ExpertAnswerType.text:
        return "Text reply";
    }
  }
}

class _ExpertConversationItem {
  const _ExpertConversationItem({
    required this.question,
    required this.requestedType,
    required this.time,
    required this.response,
  });

  final String question;
  final ExpertAnswerType requestedType;
  final String time;
  final _ExpertResponse? response;
}

class _ExpertResponse {
  const _ExpertResponse({
    required this.type,
    required this.text,
    required this.time,
  });

  final ExpertAnswerType type;
  final String text;
  final String time;
}
