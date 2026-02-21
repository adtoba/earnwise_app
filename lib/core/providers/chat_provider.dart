import 'package:earnwise_app/core/di/di.dart';
import 'package:earnwise_app/core/providers/profile_provider.dart';
import 'package:earnwise_app/core/utils/toast.dart';
import 'package:earnwise_app/domain/dto/create_chat_dto.dart';
import 'package:earnwise_app/domain/models/chat_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';
import 'package:earnwise_app/domain/repositories/chat_repository.dart';
import 'package:earnwise_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final chatNotifier = ChangeNotifierProvider((ref) => ChatProvider(ref));

class ChatProvider extends ChangeNotifier {
  late final ChatRepository chatRepository;
  late final Ref ref;

  ChatProvider(Ref r) {
    chatRepository = di.get();
    ref = r;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMessagesLoading = false;
  bool get isMessagesLoading => _isMessagesLoading;

  bool _isSendingMessage = false;
  bool get isSendingMessage => _isSendingMessage;

  List<ChatModel> _chats = [];
  List<ChatModel> get chats => _chats;

  List<ChatModel> _expertChats = [];
  List<ChatModel> get expertChats => _expertChats;

  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  bool _isExpertChatsLoading = false;
  bool get isExpertChatsLoading => _isExpertChatsLoading;

  Future<void> getUserChats() async {
    _isLoading = true;
    notifyListeners();

    final result = await chatRepository.getUserChats();
    result.fold(
      (success) {
        _isLoading = false;
        _chats = success;
        notifyListeners();
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Get user chats failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getExpertChats() async {
    _isExpertChatsLoading = true;
    notifyListeners();

    final result = await chatRepository.getExpertChats();
    result.fold(
      (success) {
        _isExpertChatsLoading = false;
        _expertChats = success;
        notifyListeners();
      },
      (failure) {
        _isExpertChatsLoading = false;
        notifyListeners();
        logger.e("Get expert chats failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> createChat(CreateChatDto createChatDto) async {
    _isLoading = true;
    notifyListeners();

    final result = await chatRepository.createChat(createChatDto: createChatDto);
    result.fold(
      (success) {
        _isLoading = false;
        notifyListeners();
        _messages.add(MessageModel(
          id: success.data["id"],
          chatId: success.data["id"],
          senderId: ref.read(profileNotifier).profile?.user?.id ?? "",
          receiverId: createChatDto.expertId,
          content: createChatDto.message,
          responseType: createChatDto.type,
          attachments: [],
          createdAt: DateTime.now().toIso8601String(),
        ));
        showSuccessToast("Chat created successfully");
      },
      (failure) {
        _isLoading = false;
        notifyListeners();
        logger.e("Create chat failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  Future<void> getChatMessages(String chatId) async {
    _messages.clear();
    _isMessagesLoading = true;
    notifyListeners();

    final result = await chatRepository.getChatMessages(chatId: chatId);
    result.fold(
      (success) {
        _messages = success;
        _isMessagesLoading = false;
        notifyListeners();
      },
      (failure) {
        _isMessagesLoading = false;
        notifyListeners();
        logger.e("Get chat messages failed: $failure");
        showErrorToast(failure);
      }
    );
  } 

  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String responseType,
    List<String>? attachments,
    required String receiverId,
    required String senderId,
    required String senderType,
  }) async {
    _isSendingMessage = true;
    notifyListeners();

    final result = await chatRepository.sendMessage(
      chatId: chatId, 
      content: content, 
      responseType: responseType, 
      attachments: attachments, 
      senderId: senderId,
      receiverId: receiverId
    );
    result.fold(
      (success) {
        _isSendingMessage = false;
        notifyListeners();
        

        _messages.add(MessageModel(
          id: success.data["id"],
          chatId: chatId,
          senderId: senderId,
          receiverId: receiverId,
          content: content,
          responseType: responseType,
          attachments: attachments,
          createdAt: DateTime.now().toIso8601String(),
        ));

        if(senderType == "user") {
          final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
          if (chatIndex != -1) {
            _chats[chatIndex].lastMessage = MessageModel(
              id: success.data["id"],
              chatId: chatId,
              senderId: senderId,
              receiverId: receiverId,
              content: content,
              responseType: responseType,
              attachments: attachments,
            );
            _promoteChatToTop(_chats, chatIndex);
          }
        } else {
          final chatIndex = _expertChats.indexWhere((chat) => chat.id == chatId);
          if (chatIndex != -1) {
            _expertChats[chatIndex].lastMessage = MessageModel(
              id: success.data["id"],
              chatId: chatId,
              senderId: senderId,
              receiverId: receiverId,
              content: content,
              responseType: responseType,
              attachments: attachments,
            );
            _promoteChatToTop(_expertChats, chatIndex);
          }
        }

        
      },
      (failure) {
        _isSendingMessage = false;
        notifyListeners();
        logger.e("Send message failed: $failure");
        showErrorToast(failure);
      }
    );
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void _promoteChatToTop(List<ChatModel> chats, int index) {
    if (index <= 0 || index >= chats.length) return;
    final chat = chats.removeAt(index);
    chats.insert(0, chat);
    notifyListeners();
  }
}