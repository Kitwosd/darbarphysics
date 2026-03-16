import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int id;
  final String title;

  final int? level;
  final String? levelName;

  final int? subject;
  final String? subjectName;

  final List<int>? streams;
  final List<String>? streamNames;

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
    this.level,
    this.levelName,
    this.subject,
    this.subjectName,
    this.streams,
    this.streamNames,
    required this.description,
    required this.cost,
    required this.image,
    required this.rating,
    required this.studentCount,
    required this.lessonCount,
    required this.liveClassCount,
    required this.isUserLocked,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    logger.d("ID: ${json["id"]}, Rating: ${json["rating"]}");

    return CourseModel(
      id: json["id"] as int,
      title: json["title"] ?? '',

      level: json['level'],
      levelName: json['level_name'],

      subject: json['subject'],
      subjectName: json['subject_name'],

      streams: (json["streams"] as List?)?.map((e) => e as int).toList() ?? [],

      streamNames:
          (json["stream_names"] as List?)?.map((e) => e as String).toList() ??
          [],

      description: json["description"] ?? '',
      cost: json["cost"] ?? '0.00',
      image: json["image"] ?? '',

      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,

      studentCount: json["studentCount"] ?? 0,
      lessonCount: json["lessonCount"] ?? 0,
      liveClassCount: json["liveclassCount"] ?? 0,

      isUserLocked: json["is_user_locked"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "level": level,
    "level_name": levelName,
    "subject": subject,
    "subject_name": subjectName,
    "streams": streams,
    "stream_names": streamNames,
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
  List<Object?> get props => [
    id,
    title,
    level,
    levelName,
    subject,
    subjectName,
    streams,
    streamNames,
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
