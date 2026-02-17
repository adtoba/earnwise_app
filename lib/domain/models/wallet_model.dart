class WalletModel {
  String? id;
  String? userId;
  String? expertId;
  double? availableBalance;
  double? pendingBalance;
  double? totalWithdrawals;
  double? totalEarnings;
  String? createdAt;
  String? updatedAt;

  WalletModel(
      {this.id,
      this.userId,
      this.expertId,
      this.availableBalance,
      this.pendingBalance,
      this.totalWithdrawals,
      this.totalEarnings,
      this.createdAt,
      this.updatedAt});

  WalletModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    expertId = json['expert_id'];
    availableBalance = json['available_balance'].toDouble();
    pendingBalance = json['pending_balance'].toDouble();
    totalWithdrawals = json['total_withdrawals'].toDouble();
    totalEarnings = json['total_earnings'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['expert_id'] = expertId;
    data['available_balance'] = availableBalance;
    data['pending_balance'] = pendingBalance;
    data['total_withdrawals'] = totalWithdrawals;
    data['total_earnings'] = totalEarnings;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
