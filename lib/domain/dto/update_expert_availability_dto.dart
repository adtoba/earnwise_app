class UpdateExpertAvailabilityDto {
  final String? day;
  final String? status; // available | unavailable
  final String? start;
  final String? end;

  UpdateExpertAvailabilityDto({this.day, this.status, this.start, this.end});

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "status": status,
      "start": start,
      "end": end,
    };
  }
}