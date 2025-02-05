class StationModel {
  StationModel({
    required this.id,
    required this.stationName,
    required this.address,
    required this.lat,
    required this.lng,
    required this.lineNumber,
    required this.lineName,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) => StationModel(
        id: int.parse(json['id'].toString()),
        stationName: json['station_name'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
        lineNumber: json['line_number'].toString(),
        lineName: json['line_name'].toString(),
      );

  int id;
  String stationName;
  String address;
  String lat;
  String lng;
  String lineNumber;
  String lineName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'station_name': stationName,
        'address': address,
        'lat': lat,
        'lng': lng,
        'line_number': lineNumber,
        'line_name': lineName,
      };
}
