import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:earnwise_app/core/utils/error_util.dart';
import 'package:earnwise_app/data/services/api_service.dart';
import 'package:earnwise_app/domain/dto/create_chat_dto.dart';
import 'package:earnwise_app/domain/models/chat_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';
import 'package:earnwise_app/domain/repositories/chat_repository.dart';

class ChatHttpRepository extends ApiService implements ChatRepository {
  @override
  Future<Either<List<ChatModel>, String>> getUserChats() async {
    try {
      final response = await http.get("/chats/user");
      if(response.data["data"] != null) {
        return left((response.data["data"] as List<dynamic>).map((e) => ChatModel.fromJson(e)).toList());
      } else {
        return left([]);
      }
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<ChatModel>, String>> getExpertChats() async {
    try {
      final response = await http.get("/chats/expert");
      if(response.data["data"] != null) {
        return left((response.data["data"] as List<dynamic>).map((e) => ChatModel.fromJson(e)).toList());
      } else {
        return left([]);
      }
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response, String>> createChat({required CreateChatDto createChatDto}) async {
    try {
      final response = await http.post("/chats/", data: createChatDto.toJson());
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<List<MessageModel>, String>> getChatMessages({required String chatId}) async {
    try {
      final response = await http.get("/chats/$chatId/messages");
      if(response.data["data"] != null) {
        return left((response.data["data"] as List<dynamic>).map((e) => MessageModel.fromJson(e)).toList());
      } else {
        return left([]);
      }
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }

  @override
  Future<Either<Response, String>> sendMessage({required String chatId, required String content, required String responseType, List<String>? attachments, required String receiverId, required String senderId}) async {
    try {
      final response = await http.post("/chats/$chatId/messages", data: {
        "content": content,
        "response_type": responseType,
        "attachments": attachments,
        "receiver_id": receiverId,
        "sender_id": senderId,
      });
      return left(response);
    } on DioException catch (e) {
      String error = ErrorUtil.parseDioError(e);
      return right(error);
    } catch (e) {
      return right(e.toString());
    }
  }
}