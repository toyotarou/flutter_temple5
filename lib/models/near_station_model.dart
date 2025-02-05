import 'dart:convert';

NearStationModel nearStationModelFromJson(String str) =>
    NearStationModel.fromJson(json.decode(str) as Map<String, dynamic>);

String nearStationModelToJson(NearStationModel data) =>
    json.encode(data.toJson());

class NearStationModel {
  NearStationModel({
    required this.response,
  });

  factory NearStationModel.fromJson(Map<String, dynamic> json) =>
      NearStationModel(
        response: NearStationResponseModel.fromJson(
            json['response'] as Map<String, dynamic>),
      );
  NearStationResponseModel response;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'response': response.toJson(),
      };
}

class NearStationResponseModel {
  NearStationResponseModel({
    required this.station,
  });

  factory NearStationResponseModel.fromJson(Map<String, dynamic> json) =>
      NearStationResponseModel(
        // ignore: avoid_dynamic_calls
        station: List<NearStationResponseStationModel>.from(json['station'].map(
            // ignore: inference_failure_on_untyped_parameter, always_specify_types
            (x) => NearStationResponseStationModel.fromJson(
                x as Map<String, dynamic>)) as Iterable<dynamic>),
      );
  List<NearStationResponseStationModel> station;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'station': List<dynamic>.from(
            station.map((NearStationResponseStationModel x) => x.toJson())),
      };
}

class NearStationResponseStationModel {
  NearStationResponseStationModel({
    required this.name,
    required this.prefecture,
    required this.line,
    required this.x,
    required this.y,
    required this.postal,
    required this.distance,
    required this.prev,
    required this.next,
  });

  factory NearStationResponseStationModel.fromJson(Map<String, dynamic> json) =>
      NearStationResponseStationModel(
        name: json['name'].toString(),
        prefecture: json['prefecture'].toString(),
        line: json['line'].toString(),
        x: (json['x'] == null) ? 0 : double.parse(json['x'].toString()),
        y: (json['y'] == null) ? 0 : double.parse(json['y'].toString()),
        postal: json['postal'].toString(),
        distance: json['distance'].toString(),
        prev: json['prev'].toString(),
        next: json['next'].toString(),
      );
  String name;
  String prefecture;
  String line;
  double x;
  double y;
  String postal;
  String distance;
  String prev;
  String next;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'prefecture': prefecture,
        'line': line,
        'x': x,
        'y': y,
        'postal': postal,
        'distance': distance,
        'prev': prev,
        'next': next,
      };
}
