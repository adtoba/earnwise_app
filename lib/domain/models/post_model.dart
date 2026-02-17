import 'package:earnwise_app/domain/models/expert_profile_model.dart';

class PostModel {
  String? id;
  String? expertId;
  String? userId;
  User? user;
  String? content;
  List<String>? attachments;
  int? likesCount;
  int? commentsCount;
  bool? isPostLiked;
  String? createdAt;
  String? updatedAt;

  PostModel(
      {this.id,
      this.expertId,
      this.userId,
      this.user,
      this.content,
      this.attachments,
      this.likesCount,
      this.commentsCount,
      this.isPostLiked,
      this.createdAt,
      this.updatedAt});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertId = json['expert_id'];
    userId = json['user_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    content = json['content'];
    attachments = json['attachments'].cast<String>();
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    isPostLiked = json['is_post_liked'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expert_id'] = expertId;
    data['user_id'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['content'] = content;
    data['attachments'] = attachments;
    data['likes_count'] = likesCount;
    data['comments_count'] = commentsCount;
    data['is_post_liked'] = isPostLiked;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
