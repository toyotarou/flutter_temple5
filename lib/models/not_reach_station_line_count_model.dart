class NotReachLineCountModel {
  NotReachLineCountModel({required this.line, required this.count});

  factory NotReachLineCountModel.fromJson(Map<String, dynamic> json) =>
      NotReachLineCountModel(
        line: json['line'].toString(),
        count: int.parse(json['count'].toString()),
      );
  String line;
  int count;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'line': line, 'count': count};
}

class NotReachStationCountModel {
  NotReachStationCountModel({required this.station, required this.count});

  factory NotReachStationCountModel.fromJson(Map<String, dynamic> json) =>
      NotReachStationCountModel(
        station: json['station'].toString(),
        count: int.parse(json['count'].toString()),
      );
  String station;
  int count;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'station': station, 'count': count};
}
