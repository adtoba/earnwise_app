class MessageModel {
  final String? id;
  final String? chatId;
  final String? senderId;
  final String? receiverId;
  final String? content;
  final String? responseType;
  final List<String>? attachments;
  final String? createdAt;

  MessageModel({this.id, this.chatId, this.senderId, this.receiverId, this.content, this.responseType, this.attachments, this.createdAt});
  
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      responseType: json['response_type'],
      attachments: json['attachments'].cast<String>(),
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'response_type': responseType,
      'attachments': attachments,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'MessageModel(id: $id, chatId: $chatId, senderId: $senderId, receiverId: $receiverId, content: $content, responseType: $responseType, attachments: $attachments, createdAt: $createdAt)';
  }
}
