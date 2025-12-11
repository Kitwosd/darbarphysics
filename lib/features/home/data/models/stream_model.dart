class StreamModel {
  final int id;
  final String name;
  final int level;

  StreamModel({required this.id, required this.name, required this.level});

  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      StreamModel(id: json["id"], name: json["name"], level: json["level"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "level": level};
}
