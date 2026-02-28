class CreateChatDto {
  final String expertId;
  final String expertUserId;
  final String message;
  final String type;

  CreateChatDto({required this.expertId, required this.expertUserId, required this.message, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'expert_id': expertId,
      'expert_user_id': expertUserId,
      'message': message,
      'response_type': type,
    };
  }
}