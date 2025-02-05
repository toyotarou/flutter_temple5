class TokyoStationModel {
  TokyoStationModel({
    required this.id,
    required this.stationName,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory TokyoStationModel.fromJson(Map<String, dynamic> json) =>
      TokyoStationModel(
        id: json['id'].toString(),
        stationName: json['station_name'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
      );

  String id;
  String stationName;
  String address;
  String lat;
  String lng;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'station_name': stationName,
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}
