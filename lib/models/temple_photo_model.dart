class TemplePhotoModel {
  TemplePhotoModel({required this.date, required this.temple, required this.templephotos});

  factory TemplePhotoModel.fromJson(Map<String, dynamic> json) => TemplePhotoModel(
        date: DateTime.parse('${json["date"]} 00:00:00'),
        temple: json['temple'].toString(),
        // ignore: inference_failure_on_untyped_parameter, avoid_dynamic_calls, always_specify_types
        templephotos: List<String>.from(json['templephotos'].map((x) => x) as Iterable<dynamic>),
      );
  DateTime date;
  String temple;
  List<String> templephotos;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date':
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        'temple': temple,
        'templephotos': List<dynamic>.from(templephotos.map((String x) => x)),
      };
}
