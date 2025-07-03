class PrefectureModel {
  PrefectureModel({this.id, this.code, this.name, this.areaId, this.createdAt, this.updatedAt});

  factory PrefectureModel.fromJson(Map<String, dynamic> json) => PrefectureModel(
        id: int.parse(json['id'].toString()),
        code: json['code'].toString(),
        name: json['name'].toString(),
        areaId: int.parse(json['area_id'].toString()),
        createdAt: json['created_at'].toString(),
        updatedAt: json['updated_at'].toString(),
      );
  int? id;
  String? code;
  String? name;
  int? areaId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'code': code, 'name': name, 'created_at': createdAt, 'updated_at': updatedAt};
}
