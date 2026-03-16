import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:equatable/equatable.dart';

class CourseDetailModel extends Equatable {
  final int id;
  final String title;

  final int? level;
  final String? levelName;

  final int? subject;
  final String? subjectName;

  // final List<int>? streams;
  // final List<String>? streamNames;

  final String description;
  final String cost;

  final DateTime? startTime;
  final DateTime? endTime;

  final String image;
  final DateTime createdAt;

  final bool isUserLocked;

  final double rating;
  final int reviewCount;
  final int studentCount;

  final String totalDuration;
  final int lessonCount;

  final List<VideoModel> lessons;

  final List<LiveClassDetailModel> liveClasses;
  final int liveClassCount;

  final bool hasRated;
  final double? userRating;

  const CourseDetailModel({
    required this.id,
    required this.title,
    this.level,
    this.levelName,
    this.subject,
    this.subjectName,
    // this.streams,
    // this.streamNames,
    required this.description,
    required this.cost,
    required this.startTime,
    required this.endTime,
    required this.image,
    required this.createdAt,
    required this.isUserLocked,
    required this.rating,
    required this.reviewCount,
    required this.studentCount,
    required this.totalDuration,
    required this.lessonCount,
    required this.lessons,
    required this.liveClasses,
    required this.liveClassCount,
    required this.hasRated,
    this.userRating,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",

      level: json["level"],
      levelName: json["level_name"],

      subject: json["subject"],
      subjectName: json["subject_name"],

      // streams: (json["streams"] as List?)?.map((e) => e as int).toList(),
      // streamNames: (json["stream_names"] as List?)
      //     ?.map((e) => e as String)
      //     .toList(),
      description: json["description"] ?? "",
      cost: json["cost"] ?? "0",

      startTime: json["start_time"] != null
          ? DateTime.parse(json["start_time"])
          : null,

      endTime: json["end_time"] != null
          ? DateTime.parse(json["end_time"])
          : null,

      image: json["image"] ?? "",

      createdAt: DateTime.parse(json["created_at"]),

      isUserLocked: json["is_user_locked"] ?? false,

      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,

      reviewCount: json["reviewCount"] ?? 0,
      studentCount: json["studentCount"] ?? 0,

      totalDuration: json["totalDuration"] ?? "0 mins",
      lessonCount: json["lessonCount"] ?? 0,

      lessons: json["lessons"] == null
          ? []
          : List<VideoModel>.from(
              json["lessons"].map((x) => VideoModel.fromJson(x)),
            ),

      liveClasses: json["liveclasses"] == null
          ? []
          : List<LiveClassDetailModel>.from(
              json["liveclasses"].map((x) => LiveClassDetailModel.fromJson(x)),
            ),

      liveClassCount: json["liveclassCount"] ?? 0,

      hasRated: json["hasRated"] ?? false,

      userRating: (json["userRating"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "level": level,
      "level_name": levelName,
      "subject": subject,
      "subject_name": subjectName,
      // "streams": streams,
      // "stream_names": streamNames,
      "description": description,
      "cost": cost,
      "start_time": startTime?.toIso8601String(),
      "end_time": endTime?.toIso8601String(),
      "image": image,
      "created_at": createdAt.toIso8601String(),
      "is_user_locked": isUserLocked,
      "rating": rating,
      "reviewCount": reviewCount,
      "studentCount": studentCount,
      "totalDuration": totalDuration,
      "lessonCount": lessonCount,
      "lessons": lessons.map((x) => x.toJson()).toList(),
      "liveclasses": liveClasses.map((x) => x.toJson()).toList(),
      "liveclassCount": liveClassCount,
      "hasRated": hasRated,
      "userRating": userRating,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    level,
    levelName,
    subject,
    subjectName,
    // streams,
    // streamNames,
    description,
    cost,
    startTime,
    endTime,
    image,
    createdAt,
    isUserLocked,
    rating,
    reviewCount,
    studentCount,
    totalDuration,
    lessonCount,
    lessons,
    liveClasses,
    liveClassCount,
    hasRated,
    userRating,
  ];
}
