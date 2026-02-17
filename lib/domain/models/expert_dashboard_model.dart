import 'package:earnwise_app/domain/models/expert_profile_model.dart';
import 'package:earnwise_app/domain/models/wallet_model.dart';

class ExpertDashboardModel {
  ExpertProfileModel? expertProfile;
  WalletModel? wallet;

  ExpertDashboardModel({this.expertProfile, this.wallet});

  ExpertDashboardModel.fromJson(Map<String, dynamic> json) {
    expertProfile = json['expert_profile'] != null ? ExpertProfileModel.fromJson(json['expert_profile']) : null;
    wallet = json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expert_profile'] = expertProfile?.toJson();
    data['wallet'] = wallet?.toJson();
    return data;
  }
}