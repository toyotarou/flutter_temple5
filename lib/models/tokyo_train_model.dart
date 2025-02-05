import 'tokyo_station_model.dart';

class TokyoTrainModel {
  TokyoTrainModel({
    required this.trainNumber,
    required this.trainName,
    required this.station,
  });

  factory TokyoTrainModel.fromJson(Map<String, dynamic> json) =>
      TokyoTrainModel(
        trainNumber: int.parse(json['train_number'].toString()),
        trainName: json['train_name'].toString(),
        station: List<TokyoStationModel>.from(

            // ignore: avoid_dynamic_calls
            (json['station'] as List<dynamic>).map(
                // ignore: always_specify_types
                (x) => TokyoStationModel.fromJson(x as Map<String, dynamic>))),
      );
  int trainNumber;
  String trainName;
  List<TokyoStationModel> station;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'train_number': trainNumber,
        'train_name': trainName,
        'station': List<dynamic>.from(
            station.map((TokyoStationModel x) => x.toJson())),
      };
}
