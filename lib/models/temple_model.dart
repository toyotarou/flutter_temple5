class TempleModel {
  TempleModel({
    required this.date,
    required this.temple,
    required this.address,
    required this.station,
    required this.memo,
    required this.gohonzon,
    required this.startPoint,
    required this.endPoint,
    required this.thumbnail,
    required this.lat,
    required this.lng,
    required this.photo,
  });

  factory TempleModel.fromJson(Map<String, dynamic> json) => TempleModel(
        date: DateTime.parse(json['date'].toString()),
        temple: json['temple'].toString(),
        address: json['address'].toString(),
        station: json['station'].toString(),
        memo: json['memo'].toString(),
        gohonzon: json['gohonzon'].toString(),
        startPoint: json['start_point'].toString(),
        endPoint: json['end_point'].toString(),
        thumbnail: json['thumbnail'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
        photo: List<String>.from(
            // ignore: avoid_dynamic_calls
            (json['photo'] as List<dynamic>).map((dynamic x) => x)),
      );

  DateTime date;
  String temple;
  String address;
  String station;
  String memo;
  String gohonzon;
  String startPoint;
  String endPoint;
  String thumbnail;
  String lat;
  String lng;
  List<String> photo;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date':
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        'temple': temple,
        'address': address,
        'station': station,
        'memo': memo,
        'gohonzon': gohonzon,
        'start_point': startPoint,
        'end_point': endPoint,
        'thumbnail': thumbnail,
        'lat': lat,
        'lng': lng,
        'photo': List<dynamic>.from(photo.map((String x) => x)),
      };
}
