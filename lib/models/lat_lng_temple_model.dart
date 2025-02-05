class LatLngTempleModel {
  LatLngTempleModel({
    required this.id,
    required this.city,
    required this.jinjachouId,
    required this.url,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.dist,
    required this.cnt,
  });

  factory LatLngTempleModel.fromJson(Map<String, dynamic> json) =>
      LatLngTempleModel(
        id: int.parse(json['id'].toString()),
        city: json['city'].toString(),
        jinjachouId: json['jinjachou_id'].toString(),
        url: json['url'].toString(),
        name: json['name'].toString(),
        address: json['address'].toString(),
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString(),
        dist: json['dist'].toString(),
        cnt: int.parse(json['cnt'].toString()),
      );

  int id;
  String city;
  String jinjachouId;
  String url;
  String name;
  String address;
  String latitude;
  String longitude;
  String dist;
  int cnt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'city': city,
        'jinjachou_id': jinjachouId,
        'url': url,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'dist': dist,
        'cnt': cnt,
      };
}
