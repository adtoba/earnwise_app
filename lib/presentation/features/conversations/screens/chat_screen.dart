import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

enum AnswerType { text, audio, video }

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  AnswerType _selectedType = AnswerType.text;

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      isUser: true,
      type: AnswerType.text,
      text: "Hi Amanda, can you review my budget plan for Q2?",
      time: "10:22 AM",
    ),
    _ChatMessage(
      isUser: false,
      type: AnswerType.video,
      text: "Video response available",
      time: "10:30 AM",
    ),
    _ChatMessage(
      isUser: true,
      type: AnswerType.text,
      text: "Thanks! Can you also advise on saving for taxes?",
      time: "10:35 AM",
    ),
    _ChatMessage(
      isUser: false,
      type: AnswerType.audio,
      text: "Audio response available",
      time: "10:44 AM",
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Palette.darkBackground : Palette.lightBackground;
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Amanda Brooks",
              style: TextStyles.largeBold.copyWith(
                color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
              ),
            ),
            Text(
              "\$30 / text answer",
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
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(
                  message: message,
                  isDarkMode: isDarkMode,
                );
              },
              separatorBuilder: (_, __) => YMargin(12),
              itemCount: _messages.length,
            ),
          ),
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
                _AnswerTypeSelector(
                  selectedType: _selectedType,
                  isDarkMode: isDarkMode,
                  onChanged: (type) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                ),
                YMargin(10),
                Row(
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
                          hintText: "Type your question...",
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
                      onPressed: () {},
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
                            "Pay",
                            style: TextStyles.smallSemiBold.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                YMargin(8),
                Row(
                  children: [
                    XMargin(10),
                    Icon(Icons.lock_outline, size: 14, color: secondaryTextColor),
                    XMargin(6),
                    Expanded(
                      child: Text(
                        "You will be charged \$30 when you send this request.",
                        style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
                      ),
                    ),
                  ],
                ),
                YMargin(10),
              ],
            ),
          ),
          YMargin(MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 6),
        ],
      ),
    );
  }
}

class _AnswerTypeSelector extends StatelessWidget {
  const _AnswerTypeSelector({
    required this.selectedType,
    required this.onChanged,
    required this.isDarkMode,
  });

  final AnswerType selectedType;
  final ValueChanged<AnswerType> onChanged;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final selectedColor = Palette.primary;
    final unselectedColor = isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;
    final unselectedText = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;

    Widget buildChip({
      required AnswerType type,
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
        buildChip(type: AnswerType.text, label: "Text", icon: Icons.chat_bubble_outline),
        XMargin(8),
        buildChip(type: AnswerType.audio, label: "Audio", icon: Icons.mic_none),
        XMargin(8),
        buildChip(type: AnswerType.video, label: "Video", icon: Icons.videocam_outlined),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.isDarkMode,
  });

  final _ChatMessage message;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.isUser
        ? Palette.primary
        : (isDarkMode ? Palette.darkFillColor : Palette.lightFillColor);
    final textColor = message.isUser ? Colors.white : (isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight);
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isUser)
          CircleAvatar(
            radius: config.sw(16),
            backgroundColor: Palette.primary.withOpacity(0.2),
            child: const Icon(Icons.person, size: 18, color: Palette.primary),
          ),
        if (!message.isUser) XMargin(8),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!message.isUser)
                  Row(
                    children: [
                      Icon(
                        _typeIcon(message.type),
                        size: 14,
                        color: textColor,
                      ),
                      XMargin(6),
                      Text(
                        _typeLabel(message.type),
                        style: TextStyles.smallSemiBold.copyWith(color: textColor),
                      ),
                    ],
                  ),
                if (!message.isUser) YMargin(6),
                Text(
                  message.text,
                  style: TextStyles.mediumMedium.copyWith(color: textColor),
                ),
                YMargin(6),
                Text(
                  message.time,
                  style: TextStyles.xSmallRegular.copyWith(
                    color: message.isUser ? Colors.white70 : secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _typeIcon(AnswerType type) {
    switch (type) {
      case AnswerType.audio:
        return Icons.graphic_eq;
      case AnswerType.video:
        return Icons.videocam;
      case AnswerType.text:
        return Icons.chat_bubble;
    }
  }

  String _typeLabel(AnswerType type) {
    switch (type) {
      case AnswerType.audio:
        return "Audio reply";
      case AnswerType.video:
        return "Video reply";
      case AnswerType.text:
        return "Text reply";
    }
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.isUser,
    required this.type,
    required this.text,
    required this.time,
  });

  final bool isUser;
  final AnswerType type;
  final String text;
  final String time;
}