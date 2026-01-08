class CourseModel {
  final int id;
  final String title;
  final String description;
  final String cost;
  final String image;
  final double rating;
  final int studentCount;
  final int lessonCount;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.image,
    required this.rating,
    required this.studentCount,
    required this.lessonCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    cost: json["cost"],
    image: json["image"],
    rating: json["rating"]?.toDouble(),
    studentCount: json["studentCount"],
    lessonCount: json["lessonCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "cost": cost,
    "image": image,
    "rating": rating,
    "studentCount": studentCount,
    "lessonCount": lessonCount,
  };
}
