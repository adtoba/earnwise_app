class CreatePostDto {
  final String expertId;
  final String content;
  final List<String>? attachments;

  CreatePostDto({required this.expertId, required this.content, this.attachments});

  Map<String, dynamic> toJson() {
    return {
      "expert_id": expertId,
      "content": content,
      "attachments": attachments,
    };
  }
}