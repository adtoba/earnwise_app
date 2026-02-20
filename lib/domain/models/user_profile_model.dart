import 'package:earnwise_app/domain/models/expert_profile_model.dart';

class UserProfileModel {
  User? user;
  ExpertProfileModel? expertProfile;

  UserProfileModel({this.user, this.expertProfile});

  Map<String, dynamic> toJson() {
    return {
      "user": user?.toJson(),
      "expert_profile": expertProfile?.toJson(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      user: json["user"] != null ? User.fromJson(json["user"]) : null,
      expertProfile: json["expert_profile"] != null ? ExpertProfileModel.fromJson(json["expert_profile"]) : null,
    );
  }
}