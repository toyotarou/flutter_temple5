class TempleLatLngModel {
  TempleLatLngModel({
    required this.temple,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory TempleLatLngModel.fromJson(Map<String, dynamic> json) =>
      TempleLatLngModel(
        temple: json['temple'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
      );

  String temple;
  String address;
  String lat;
  String lng;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'temple': temple,
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}
