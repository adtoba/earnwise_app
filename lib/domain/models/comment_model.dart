import 'package:earnwise_app/domain/models/expert_profile_model.dart';

class CommentModel {
  String? id;
  String? postId;
  String? userId;
  User? user;
  String? comment;
  int? likesCount;
  String? createdAt;
  String? updatedAt;

  CommentModel(
      {this.id,
      this.postId,
      this.userId,
      this.comment,
      this.likesCount,
      this.createdAt,
      this.updatedAt});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    comment = json['comment'];
    likesCount = json['likes_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    data['user_id'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['comment'] = comment;
    data['likes_count'] = likesCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
