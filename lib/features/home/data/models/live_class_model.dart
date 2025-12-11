class LiveClassModel {
  final int id;
  final String title;

  LiveClassModel({required this.id, required this.title});

  factory LiveClassModel.fromJson(Map<String, dynamic> json) =>
      LiveClassModel(id: json["id"], title: json["title"]);

  Map<String, dynamic> toJson() => {"id": id, "title": title};
}
