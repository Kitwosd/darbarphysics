import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LiveClassModel extends Equatable {
  final int id;
  final String title;
  final String thumbnail;
  final String teacherName;
  final DateTime startTime;
  final bool isLive; // 'live', 'upcoming', 'ended'
  final String meetingUrl;
  final String? password;
  final String status;
  final bool isUserLocked;
  final int course;
  final String? levelName;
  final String? subjectName;

  const LiveClassModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.teacherName,
    required this.startTime,
    required this.isLive,
    required this.meetingUrl,
    required this.status,
    this.password,
    required this.isUserLocked,
    required this.course,
    this.levelName,
    this.subjectName,
  });

  factory LiveClassModel.fromJson(Map<String, dynamic> json) {
    final baseUrl = dotenv.env['BASE_THUMBNAIL_URL'];
    String thumbnailPath = json['thumbnail'];
    if (thumbnailPath.isNotEmpty && !thumbnailPath.startsWith('http')) {
      thumbnailPath = '$baseUrl$thumbnailPath';
    }

    return LiveClassModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? '',
      thumbnail: thumbnailPath,
      teacherName: json["teacher"] ?? 'Unknown Teacher',
      startTime: json["startTime"] != null
          ? DateTime.parse(json["startTime"])
          : DateTime.now(),
      isLive: json["is_live"],
      meetingUrl: json["meetingUrl"] ?? '',
      password: json["password"],
      isUserLocked: json["is_user_locked"] ?? false,
      status: json["status"],
      course: json["course"],
      levelName: json['level_name'],
      subjectName: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "teacherName": teacherName,
    "startTime": startTime.toIso8601String(),
    "is_live": isLive,
    "meetingUrl": meetingUrl,
    "password": password,
    "status": status,
    "is_user_locked": isUserLocked,
    "course": course,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    thumbnail,
    teacherName,
    startTime,
    isLive,
    meetingUrl,
    password,
    status,
    isUserLocked,
    course,
    levelName,
    subjectName,
  ];
}
