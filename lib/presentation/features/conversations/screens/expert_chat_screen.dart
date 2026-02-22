import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:earnwise_app/core/constants/constants.dart';
import 'package:earnwise_app/core/providers/chat_provider.dart';
import 'package:earnwise_app/core/utils/spacer.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/models/chat_model.dart';
import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';
import 'package:earnwise_app/main.dart';
import 'package:earnwise_app/presentation/styles/palette.dart';
import 'package:earnwise_app/presentation/styles/textstyle.dart';
import 'package:earnwise_app/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
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
  String? _editingMessageId;

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
                      final isUserMessage = message.senderId == widget.chat?.user?.id;
                      final responseIndex = isUserMessage ? _findResponseIndex(messages, message.id) : null;
                      final hasResponse = responseIndex != null;
                      return _ExpertConversationCard(
                        message: message,
                        isDarkMode: isDarkMode,
                        user: user,
                        isUser: isUserMessage,
                        isActive: _activeReplyIndex == index,
                        hasResponse: hasResponse,
                        onReply: () {
                          setState(() {
                            _selectedType = message.responseType == "audio" ? ExpertAnswerType.audio : message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text;
                            _activeReplyIndex = index;
                            _editingMessageId = null;
                            _messageController.clear();
                          });
                        },
                        onEditResponse: hasResponse
                            ? () {
                                final responseMessage = messages[responseIndex];
                                setState(() {
                                  _selectedType = responseMessage.responseType == "audio"
                                      ? ExpertAnswerType.audio
                                      : responseMessage.responseType == "video"
                                          ? ExpertAnswerType.video
                                          : ExpertAnswerType.text;
                                  _activeReplyIndex = index;
                                  _editingMessageId = responseMessage.id;
                                  _messageController.text = responseMessage.content ?? "";
                                });
                              }
                            : null,
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
                      messages: messages
                    ),
                    if (_editingMessageId != null) ...[
                      YMargin(6),
                      Row(
                        children: [
                          Icon(Icons.edit, size: 14, color: secondaryTextColor),
                          XMargin(6),
                          Text(
                            "Editing previous response",
                            style: TextStyles.xSmallRegular.copyWith(color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ],
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
    required List<MessageModel> messages,
  }) {
    if (_selectedType == ExpertAnswerType.audio) {
      return _AudioComposer(
        isDarkMode: isDarkMode,
        responseToMessage: _activeReplyIndex != null ? messages[_activeReplyIndex!] : null,
        chat: widget.chat,
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
              if (_editingMessageId != null) {
                ref.read(chatNotifier).updateMessageContent(
                  messageId: _editingMessageId!,
                  content: _messageController.text,
                );
              } else {
                ref.read(chatNotifier).sendMessage(
                  chatId: widget.chat?.id ?? "",
                  receiverId: widget.chat?.user?.id ?? "",
                  content: _messageController.text,
                  contentType: "text",
                  responseType: _selectedType.name,
                  senderId: widget.chat?.expertId ?? "",
                  senderType: "expert",
                  isResponseTo: _activeReplyIndex != null ? messages[_activeReplyIndex!].content : null,
                  responseToId: _activeReplyIndex != null ? messages[_activeReplyIndex!].id : null,
                  attachments: [],
                );
              }
              setState(() {
                _messageController.clear();
                _editingMessageId = null;
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

  int? _findResponseIndex(List<MessageModel> messages, String? questionId) {
    if (questionId == null) return null;
    final index = messages.indexWhere(
      (message) =>
          message.responseToId == questionId &&
          message.senderId == widget.chat?.expertId,
    );
    return index == -1 ? null : index;
  }
}

class _AudioComposer extends ConsumerStatefulWidget {
  const _AudioComposer({
    required this.isDarkMode,
    required this.onSend,
    required this.chat,
    required this.responseToMessage,
  });

  final bool isDarkMode;
  final VoidCallback onSend;
  final ChatModel? chat;
  final MessageModel? responseToMessage;

  @override
  ConsumerState<_AudioComposer> createState() => _AudioComposerState();
}

class _AudioComposerState extends ConsumerState<_AudioComposer> {

  final recorderController = RecorderController();

  bool isRecording = false;

  String? recordedAudioPath;

  Duration recordedDuration = Duration.zero;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      recorderController.onCurrentDuration.listen((duration) {
        setState(() {
          recordedDuration = duration;
        });
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final surfaceColor = widget.isDarkMode ? Palette.surfaceButtonDark : Palette.surfaceButtonLight;
    final textColor = widget.isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    
    if(isRecording) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                isRecording = false;
              });
              clearRecording();
            }, 
            icon: Icon(
              Icons.delete_outline, 
              color: Colors.red,
            ),
          ),
          Text(
            "${recordedDuration.inMinutes}:${recordedDuration.inSeconds.toString().padLeft(2, '0')}",
            textAlign: TextAlign.center,
            style: TextStyles.mediumRegular.copyWith(color: textColor),
          ),
          IconButton(
            onPressed: () {
              sendRecording();
            },
            icon: Icon(
              Icons.send, 
              color: Palette.primary,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              startRecording();
            },
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
                      "Tap to record",
                      textAlign: TextAlign.center,
                      style: TextStyles.mediumRegular.copyWith(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        XMargin(10),
        ElevatedButton(
          onPressed: widget.onSend,
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

  void startRecording() async {
    await recorderController.checkPermission();
    logger.e("hasPermission: ${recorderController.hasPermission}");
    if(!recorderController.hasPermission) {
      await Permission.microphone.request();
    } 

    if(recorderController.hasPermission) {
      setState(() {
        isRecording = true;
      });
      await recorderController.record();
    } else {
      showErrorToast("Permission denied");
    }
  }

  void sendRecording() async {
    setState(() {
      isRecording = false;
    });

    if(recorderController.isRecording) {
      recordedAudioPath = await recorderController.stop();
      logger.i("recordedAudioPath: $recordedAudioPath");
    }

    ref.read(chatNotifier).sendMessage(
      chatId: widget.chat?.id ?? "",
      receiverId: widget.chat?.user?.id ?? "",
      contentType: "audio",
      content: "",
      audioPath: recordedAudioPath,
      responseType: ExpertAnswerType.audio.name,
      senderId: widget.chat?.expertId ?? "",
      senderType: "expert",
      isResponseTo: widget.responseToMessage?.content,
      responseToId: widget.responseToMessage?.id,
      attachments: [],
    );
  }

  void clearRecording() {
    setState(() {
      recordedDuration = Duration.zero;
      isRecording = false;
      recordedAudioPath = null;
    });

    if(recorderController.isRecording) {
      recorderController.stop();
    }
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

class _ExpertConversationCard extends StatefulWidget {
  const _ExpertConversationCard({
    required this.message,
    required this.isDarkMode,
    required this.isActive,
    required this.onReply,
    required this.isUser,
    required this.user,
    required this.hasResponse,
    required this.onEditResponse,
  });

  final MessageModel message;
  final bool isDarkMode;
  final bool isActive;
  final bool isUser;
  final User? user;
  final VoidCallback onReply; 
  final bool hasResponse;
  final VoidCallback? onEditResponse;

  @override
  State<_ExpertConversationCard> createState() => _ExpertConversationCardState();
}

class _ExpertConversationCardState extends State<_ExpertConversationCard> {

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
    final questionBubbleColor = widget.isDarkMode ? Palette.darkFillColor : Palette.lightFillColor;
    final questionTextColor = widget.isDarkMode ? Palette.textGeneralDark : Palette.textGeneralLight;
    final responseBubbleColor = Palette.primary;
    final responseTextColor = Colors.white;
    final secondaryTextColor = widget.isDarkMode ? Palette.textGreyscale700Dark : Palette.textGreyscale700Light;
    final highlightBorderColor = widget.isDarkMode ? Palette.primary.withOpacity(0.8) : Palette.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.isUser)...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: config.sw(16),
                backgroundColor: Palette.primary.withOpacity(0.2),
                backgroundImage: widget.user?.profilePicture != "" ? NetworkImage(widget.user?.profilePicture ?? "") : null,
              ),
              XMargin(8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: config.sw(14), vertical: config.sh(12)),
                  decoration: BoxDecoration(
                    color: questionBubbleColor,
                    borderRadius: BorderRadius.circular(16),
                    border: widget.isActive ? Border.all(color: highlightBorderColor, width: 1.4) : null,
                    boxShadow: widget.isActive
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
                            _typeIcon(widget.message.responseType == "audio" ? ExpertAnswerType.audio : widget.message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text),
                            size: 14,
                            color: questionTextColor,
                          ),
                          XMargin(6),
                          Text(
                            "${_typeLabel(widget.message.responseType == "audio" ? ExpertAnswerType.audio : widget.message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text)} requested",
                            style: TextStyles.smallSemiBold.copyWith(color: questionTextColor),
                          ),
                          Spacer(),
                          if (widget.hasResponse)
                            TextButton(
                              onPressed: widget.onEditResponse,
                              style: TextButton.styleFrom(
                                foregroundColor: Palette.primary,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: Text(
                                "Edit response",
                                style: TextStyles.smallSemiBold.copyWith(color: Palette.primary),
                              ),
                            )
                          else
                            TextButton(
                              onPressed: widget.onReply,
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
                        widget.message.content ?? "",
                        style: TextStyles.mediumMedium.copyWith(color: questionTextColor),
                      ),
                      YMargin(6),
                      Text(
                        timeago.format(DateTime.parse(widget.message.createdAt ?? "")),
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
                              _typeIcon(widget.message.responseType == "audio" ? ExpertAnswerType.audio : widget.message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text),
                              size: 14,
                              color: responseTextColor,
                            ),
                            XMargin(6),
                            Text(
                              _typeLabel(widget.message.responseType == "audio" ? ExpertAnswerType.audio : widget.message.responseType == "video" ? ExpertAnswerType.video : ExpertAnswerType.text),
                              style: TextStyles.smallSemiBold.copyWith(color: responseTextColor),
                            ),
                          ],
                        ),
                        YMargin(6),
                        if(widget.message.contentType == "audio") ...[
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: responseTextColor,
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
                                    inactiveTrackColor: Colors.white60,
                                    activeTrackColor: Colors.white,
                                    thumbColor: Colors.white
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
                                  color: responseTextColor,
                                  fontSize: config.sp(11),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        ] else if (widget.message.contentType == "text") ...[
                          Text(
                            widget.message.content ?? "",
                            style: TextStyles.mediumRegular.copyWith(color: responseTextColor),
                          ),
                        ] else ...[
                          Text(
                            widget.message.content ?? "",
                            style: TextStyles.mediumRegular.copyWith(color: responseTextColor),
                          ),
                        ],
                        
                        YMargin(6),
                        Text(
                          timeago.format(DateTime.parse(widget.message.createdAt ?? "")),
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
