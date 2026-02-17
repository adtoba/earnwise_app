class UpdateExpertRateDto {
  final double? textRate;
  final double? videoRate;
  final double? callRate;

  UpdateExpertRateDto({this.textRate, this.videoRate, this.callRate});

  Map<String, dynamic> toJson() {
    return {
      "text": textRate,
      "video": videoRate,
      "call": callRate,
    };
  }
}