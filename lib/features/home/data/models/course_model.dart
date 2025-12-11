class CourseModel {
  final int id;
  final String title;
  final String description;
  final String cost;
  final DateTime startTime;
  final DateTime endTime;
  final String image;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.startTime,
    required this.endTime,
    required this.image,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    cost: json["cost"],
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "cost": cost,
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "image": image,
    "created_at": createdAt.toIso8601String(),
  };
}
