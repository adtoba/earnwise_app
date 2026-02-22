import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/domain/dto/create_chat_dto.dart';
import 'package:earnwise_app/domain/models/chat_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';

abstract class ChatRepository {
  Future<Either<List<ChatModel>, String>> getUserChats();
  Future<Either<List<ChatModel>, String>> getExpertChats();
  Future<Either<List<MessageModel>, String>> getChatMessages({required String chatId});
  Future<Either<Response, String>> sendMessage({
    required String chatId, 
    required String content, 
    String? contentType,
    required String responseType, 
    List<String>? attachments, 
    required String receiverId, 
    required String senderId,
    String? isResponseTo,
    String? responseToId,
  });
  Future<Either<Response, String>> updateMessageContent({required String messageId, required String content});
  Future<Either<Response, String>> createChat({required CreateChatDto createChatDto});
}