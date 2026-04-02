import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VideoModel extends Equatable {
  final int id;
  final String title;
  final bool isLocked;
  // final String teacher;
  final int? course;
  final String videoUrl;
  final String? thumbnail;
  final String duration;
  final bool isUserLocked;
  final String? levelName;
  final String? subjectName;

  const VideoModel({
    required this.id,
    required this.title,
    // required this.teacher,
    this.course,
    this.videoUrl = "",
    this.thumbnail = "",
    this.duration = "00:00",
    required this.isLocked,
    required this.isUserLocked,
    this.levelName,
    this.subjectName,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final baseUrl = dotenv.env['BASE_THUMBNAIL_URL'];
    String thumbnailPath = json['thumbnail'] ?? '';
    if (thumbnailPath.isNotEmpty && !thumbnailPath.startsWith('http')) {
      thumbnailPath = '$baseUrl$thumbnailPath';
    }
    return VideoModel(
      // id: json["id"],
      // title: json["title"],
      // // teacher: json["teacher"],
      // course: json["course"],

      // videoUrl: json["videoUrl"] ?? "",
      // thumbnail: thumbnailPath,
      // duration: json["duration"] ?? "00:00",
      // isLocked: json["isLocked"] ?? true,
      // isUserLocked: json["is_user_locked"] ?? true,
      // levelName: json['level_name'],
      // subjectName: json['subject_name'],
      id: json["id"], // ✅ SAFE fallback
      title: json["title"] ?? "No Title",
      course: json["course"],
      videoUrl: json["videoUrl"] ?? "",
      thumbnail: thumbnailPath,
      duration: json["duration"] ?? "",
      isLocked: json["isLocked"] ?? true,
      isUserLocked: json["is_user_locked"] ?? true,
      levelName: json['level_name'],
      subjectName: json['subject_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    // "teacher": teacher,
    "course": course,
    "video_url": videoUrl,
    "thumbnail": thumbnail,
    "duration": duration,
    "isLocked": isLocked,
    "is_user_locked": isUserLocked,
  };

  @override
  List<Object?> get props {
    return [
      id,
      title,
      videoUrl,
      duration,
      isLocked,
      isUserLocked,
      levelName,
      subjectName,
    ];
  }
}
