class CreateChatDto {
  final String expertId;
  final String message;
  final String type;

  CreateChatDto({required this.expertId, required this.message, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'expert_id': expertId,
      'message': message,
      'response_type': type,
    };
  }
}