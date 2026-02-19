class ReviewModel {
  String? id;
  String? expertId;
  String? userId;
  String? comment;
  String? fullName;
  double? rating;
  String? createdAt;
  String? updatedAt;

  ReviewModel({this.id, this.expertId, this.userId, this.comment, this.fullName, this.rating, this.createdAt, this.updatedAt});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expertId = json['expert_id'];
    userId = json['user_id'];
    comment = json['comment'];
    fullName = json['full_name'];
    rating = json['rating'].toDouble();
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['expert_id'] = expertId;
    data['user_id'] = userId;
    data['comment'] = comment;
    data['full_name'] = fullName;
    data['rating'] = rating;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, expertId: $expertId, userId: $userId, comment: $comment, fullName: $fullName, rating: $rating, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}