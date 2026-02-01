import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String cost;
  final String image;
  final double rating;
  final int studentCount;
  final int lessonCount;
  final int liveClassCount;
  final bool isUserLocked;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.image,
    required this.rating,
    required this.studentCount,
    required this.lessonCount,
    required this.liveClassCount,
    required this.isUserLocked,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    id: json["id"] as int,
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    cost: json["cost"] ?? '0.00',
    image: json["image"] ?? '',
    rating: (json["rating"] as num?)?.toDouble() ?? 0.0,

    studentCount: json["studentCount"] ?? 0,
    lessonCount: json["lessonCount"] ?? 0,
    liveClassCount: json["liveclassCount"] ?? 0,
    isUserLocked: json["is_user_locked"] ?? false,
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
    "liveclassCount": liveClassCount,
    "is_user_locked": isUserLocked,
  };

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      cost,
      image,
      rating,
      studentCount,
      lessonCount,
      liveClassCount,
      isUserLocked,
    ];
  }
}
