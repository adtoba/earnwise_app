import 'package:earnwise_app/domain/models/expert_profile_model.dart';

class CallModel {
  String? id;
  String? userId;
  String? expertId;
  User? user;
  ExpertProfileModel? expert;
  String? scheduledAt;
  int? durationMins;
  String? status;
  int? price;
  String? subject;
  String? description;
  String? paymentStatus;
  String? paymentRef;
  String? createdAt;
  String? updatedAt;

  CallModel(
      {this.id,
      this.userId,
      this.expertId,
      this.user,
      this.expert,
      this.scheduledAt,
      this.durationMins,
      this.status,
      this.price,
      this.paymentStatus,
      this.paymentRef,
      this.createdAt,
      this.updatedAt});

  CallModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    expertId = json['expert_id'];
    subject = json['subject'];
    description = json['description'];
    user = json['user'] != null ?  User.fromJson(json['user']) : null;
    expert =
        json['expert'] != null ? ExpertProfileModel.fromJson(json['expert']) : null;
    scheduledAt = json['scheduled_at'];
    durationMins = json['duration_mins'];
    status = json['status'];
    price = json['price'];
    paymentStatus = json['payment_status'];
    paymentRef = json['payment_ref'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['subject'] = subject;
    data['description'] = description;
    data['expert_id'] = expertId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (expert != null) {
      data['expert'] = expert!.toJson();
    }
    data['scheduled_at'] = scheduledAt;
    data['duration_mins'] = durationMins;
    data['status'] = status;
    data['price'] = price;
    data['payment_status'] = paymentStatus;
    data['payment_ref'] = paymentRef;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
