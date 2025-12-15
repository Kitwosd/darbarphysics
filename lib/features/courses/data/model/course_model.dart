import 'package:dubar_physics/features/courses/data/model/lesson_model.dart';
import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String cost;
  final DateTime startTime;
  final DateTime endTime;
  final String image;
  final DateTime createdAt;
  final double rating;
  final int reviewCount;
  final int studentCount;
  final String totalDuration;
  final int lessonCount;
  final List<LessonModel> lessons;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.startTime,
    required this.endTime,
    required this.image,
    required this.createdAt,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.studentCount = 0,
    this.totalDuration = "0h 0m",
    this.lessonCount = 0,
    this.lessons = const [],
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
    rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
    reviewCount: json["review_count"] ?? 0,
    studentCount: json["student_count"] ?? 0,
    totalDuration: json["total_duration"] ?? "0h 0m",
    lessonCount: json["lesson_count"] ?? 0,
    lessons: json["lessons"] == null
        ? []
        : List<LessonModel>.from(
            json["lessons"].map((x) => LessonModel.fromJson(x)),
          ),
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
    "rating": rating,
    "review_count": reviewCount,
    "student_count": studentCount,
    "total_duration": totalDuration,
    "lesson_count": lessonCount,
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
  };

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    cost,
    startTime,
    endTime,
    image,
    createdAt,
    rating,
    reviewCount,
    studentCount,
    totalDuration,
    lessonCount,
    lessons,
  ];
}
