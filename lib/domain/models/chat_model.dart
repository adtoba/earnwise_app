import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/message_model.dart';

class ChatModel {
  final String? id;
  final String? expertId;
  final String? userId;
  final User? user;
  final ExpertProfileModel? expert;
  MessageModel? lastMessage;
  final String? createdAt;
  final String? updatedAt;

  ChatModel({this.id, this.expertId, this.userId, this.user, this.expert, this.lastMessage, this.createdAt, this.updatedAt});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      expertId: json['expert_id'],
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      expert: json['expert'] != null ? ExpertProfileModel.fromJson(json['expert']) : null,
      lastMessage: json['last_message'] != null ? MessageModel.fromJson(json['last_message']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expert_id': expertId,
      'user_id': userId,
      'user': user?.toJson(),
      'expert': expert?.toJson(),
      'last_message': lastMessage?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, expertId: $expertId, userId: $userId, user: $user, expert: $expert, lastMessage: $lastMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}