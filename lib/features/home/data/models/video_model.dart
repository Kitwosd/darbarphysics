class VideoModel {
  final int id;
  final String title;
  final int teacher;
  final int? course;

  VideoModel({
    required this.id,
    required this.title,
    required this.teacher,
    this.course,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: json["id"],
    title: json["title"],
    teacher: json["teacher"],
    course: json["course"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "teacher": teacher,
    "course": course,
  };
}
