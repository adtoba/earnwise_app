class SlotModel {
  String? start;
  String? end;

  SlotModel({this.start, this.end});

  SlotModel.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }

  @override
  String toString() {
    return 'SlotModel(start: $start, end: $end)';
  }
}