import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/chat_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/domain/dto/create_chat_dto.dart';
import 'package:earnwise_app/domain/models/chat_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, this.chat});

  final ChatModel? chat;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

enum AnswerType { text, audio, video }

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  AnswerType _selectedType = AnswerType.text;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.chat?.id != null) {
        ref.read(chatNotifier).getChatMessages(widget.chat?.id ?? "");
      }
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
    final isWaitingForExpertReply = messages.isNotEmpty &&
        messages.last.senderId == widget.chat?.userId;
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
                "${expert?.user?.firstName ?? ""} ${expert?.user?.lastName ?? ""}",
                style: TextStyles.largeBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              Text(
                "\$${expert?.rates?.text ?? 0} / text answer",
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
                : messages.isEmpty
                  ? _EmptyChatState(isDarkMode: isDarkMode)
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(16)),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _ChatBubble(
                          message: message,
                          isDarkMode: isDarkMode,
                          expert: expert,
                          isUser: message.senderId == widget.chat?.userId,
                        );
                      },
                      separatorBuilder: (_, __) => YMargin(12),
                      itemCount: messages.length,
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
                          enabled: !isWaitingForExpertReply,
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
                        onPressed: isWaitingForExpertReply ? null : () {
                          if(messages.isEmpty) {
                            var chatDto = CreateChatDto(
                              expertId: expert?.id ?? "",
                              message: _messageController.text,
                              type: _selectedType.name,
                            );
                            setState(() {
                              _messageController.clear();
                            });
                            chatProvider.createChat(chatDto);
                          } else {
                            chatProvider.sendMessage(
                              chatId: widget.chat?.id ?? "",
                              content: _messageController.text,
                              responseType: _selectedType.name,
                              contentType: "text",
                              attachments: [],
                              senderId: widget.chat?.userId ?? "",
                              senderType: "user",
                              receiverId: expert?.id ?? "",
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
                          isWaitingForExpertReply
                              ? "Waiting for the expert’s reply before you can send another message."
                              : "You will be charged \$30 when you send this request.",
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
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final borderColor = isDarkMode ? Palette.borderDark : Palette.borderLight;
    final secondaryTextColor = isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: config.sw(24)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: config.sw(20), vertical: config.sh(18)),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: config.sw(26),
                backgroundColor: Palette.primary.withOpacity(0.12),
                child: const Icon(Icons.chat_bubble_outline, color: Palette.primary),
              ),
              YMargin(12),
              Text(
                "Start the conversation",
                style: TextStyles.largeSemiBold.copyWith(
                  color: isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight,
                ),
              ),
              YMargin(8),
              Text(
                "Write your message, choose how you want an answer, then tap Pay to send. Your expert will respond here.",
                textAlign: TextAlign.center,
                style: TextStyles.smallRegular.copyWith(color: secondaryTextColor),
              ),
              YMargin(12),
              _StepRow(
                label: "1. Write a message",
                isDarkMode: isDarkMode,
              ),
              YMargin(8),
              _StepRow(
                label: "2. Pay securely",
                isDarkMode: isDarkMode,
              ),
              YMargin(8),
              _StepRow(
                label: "3. Start chatting",
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.label, required this.isDarkMode});

  final String label;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, size: 16, color: Palette.primary),
        XMargin(8),
        Text(
          label,
          style: TextStyles.smallSemiBold.copyWith(color: textColor),
        ),
      ],
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

class _ChatBubble extends StatefulWidget {
  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.expert,
    required this.isDarkMode,
  });

  final MessageModel message;
  final bool isUser;
  final bool isDarkMode;
  final ExpertProfileModel? expert;

  @override
  State<_ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<_ChatBubble> {

  final player = AudioPlayer();
  Duration _total = Duration.zero;
  Duration _position = Duration.zero;

  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bindPlayerStreams();
  }

  void _bindPlayerStreams() {
    // Duration updates
    player.durationStream.listen((d) {
      if (!mounted) return;
      setState(() => _total = d ?? Duration.zero);
    });
    // Position updates
    player.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
    // Completion / buffering / playing
    player.playerStateStream.listen((state) {
      if (!mounted) return;
      final playing = state.playing;
      final processing = state.processingState;
      setState(() {
        _isPlaying = playing && processing != ProcessingState.completed;
        _isLoading = processing == ProcessingState.loading || processing == ProcessingState.buffering;
      });
      if (processing == ProcessingState.completed) {
        // Reset to start on completion
        player.pause();
        player.seek(Duration.zero);
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _toggle() async {
    if (_isPlaying) {
      await player.pause();
      return;
    }
    if (player.processingState == ProcessingState.idle) {
      setState(() => _isLoading = true);
      // if(widget.message.contentType == "audio") {
      //   await player.setAudioSource(AudioSource.file(widget.message.content ?? ""));
      // } else {
        await player.setAudioSource(LockCachingAudioSource(Uri.parse(widget.message.content ?? "")));
      // }
      await player.setLoopMode(LoopMode.off);
    }
    await player.play();
  }

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$mm:$ss";
  }
  
  @override
  Widget build(BuildContext context) {
    final bubbleColor = widget.isUser
        ? Palette.primary
        : (widget.isDarkMode ? Palette.darkFillColor : Palette.lightFillColor);
    final textColor = widget.isUser ? Colors.white : (widget.isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight);
    final secondaryTextColor = widget.isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!widget.isUser)
          CircleAvatar(
            radius: config.sw(16),
            backgroundImage: widget.expert?.user?.profilePicture != "" ? NetworkImage(widget.expert?.user?.profilePicture ?? "") : null,
            backgroundColor: Palette.primary.withOpacity(0.2),
          ),
        if (!widget.isUser) XMargin(8),
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
                if (!widget.isUser)
                  Row(
                    children: [
                      Icon(
                        _typeIcon(widget.message.responseType == "audio" ? AnswerType.audio : widget.message.responseType == "video" ? AnswerType.video : AnswerType.text),
                        size: 14,
                        color: textColor,
                      ),
                      XMargin(6),
                      Text(
                        _typeLabel(widget.message.responseType == "audio" ? AnswerType.audio : widget.message.responseType == "video" ? AnswerType.video : AnswerType.text),
                        style: TextStyles.smallSemiBold.copyWith(color: textColor),
                      ),
                    ],
                  ),
                if (!widget.isUser) YMargin(6),
                if(widget.message.contentType == "audio") ...[
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: textColor,
                        ),
                        onPressed: () {
                          _toggle();
                        },
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: SliderComponentShape.noOverlay,
                            inactiveTrackColor: textColor.withOpacity(0.2),
                            activeTrackColor: textColor,
                            thumbColor: textColor,
                          ),
                          child: Slider(
                            min: 0,
                            max: _total.inMilliseconds.toDouble().clamp(0, double.infinity),
                            value: _position.inMilliseconds.clamp(0, _total.inMilliseconds).toDouble(),
                            onChanged: (v) {
                              final target = Duration(milliseconds: v.toInt());
                              player.seek(target);
                            },
                          ),
                        ),
                      ),
                      XMargin(6),
                      Text(
                        _isPlaying ? "${_fmt(_position)} / ${_fmt(_total)}" : "00:00",
                        style: TextStyle(
                          color: textColor,
                          fontSize: config.sp(11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ] else if(widget.message.contentType == "text")...[
                  Text(
                    widget.message.content ?? "",
                    style: TextStyles.mediumMedium.copyWith(color: textColor),
                  ),
                ] else ...[
                  Text(
                    widget.message.content ?? "",
                    style: TextStyles.mediumMedium.copyWith(color: textColor),
                  ),
                ],
                YMargin(6),
                Text(
                  timeago.format(DateTime.parse(widget.message.createdAt ?? "")),
                  style: TextStyles.xSmallRegular.copyWith(
                    color: widget.isUser ? Colors.white70 : secondaryTextColor,
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
