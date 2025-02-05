class ComplementTempleVisitedDateModel {
  ComplementTempleVisitedDateModel({required this.id, required this.temple, required this.date});

  factory ComplementTempleVisitedDateModel.fromJson(Map<String, dynamic> json) => ComplementTempleVisitedDateModel(
        id: json['id'].toString(),
        temple: json['temple'].toString(),
        date: List<DateTime>.from(
          // ignore: inference_failure_on_untyped_parameter, avoid_dynamic_calls, always_specify_types
          json['date'].map((x) => DateTime.parse(x.toString())) as Iterable<dynamic>,
        ),
      );
  String id;
  String temple;
  List<DateTime> date;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'temple': temple,
        'date': List<dynamic>.from(
          date.map(
            (DateTime x) =>
                "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}",
          ),
        ),
      };
}
