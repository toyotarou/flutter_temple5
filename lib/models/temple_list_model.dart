class TempleListModel {
  TempleListModel({
    required this.id,
    required this.city,
    required this.jinjachouId,
    required this.url,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.nearStation,
  });

  factory TempleListModel.fromJson(Map<String, dynamic> json) =>
      TempleListModel(
        id: int.parse(json['id'].toString()),
        city: json['city'].toString(),
        jinjachouId: json['jinjachou_id'].toString(),
        url: json['url'].toString(),
        name: json['name'].toString(),
        address: json['address'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
        nearStation: json['near_station'].toString(),
      );

  int id;
  String city;
  String jinjachouId;
  String url;
  String name;
  String address;
  String lat;
  String lng;
  String nearStation;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'city': city,
        'jinjachou_id': jinjachouId,
        'url': url,
        'name': name,
        'address': address,
        'lat': lat,
        'lng': lng,
        'near_station': nearStation,
      };
}
