// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LessonModel extends Equatable {
  final int id;
  final String title;
  final String duration; // e.g., "04:30"
  final bool isLocked;
  final String thumbnail;
  final String videoUrl;

  const LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.isLocked,
    required this.thumbnail,
    required this.videoUrl,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
    id: json["id"],
    title: json["title"],
    duration: json["duration"] ?? "00:00",
    isLocked: json["is_locked"] ?? true,
    thumbnail: json["thumbnail"] ?? "",
    videoUrl: json["video_url"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "duration": duration,
    "is_locked": isLocked,
    "thumbnail": thumbnail,
    "video_url": videoUrl,
  };

  @override
  List<Object> get props {
    return [id, title, duration, isLocked, thumbnail, videoUrl];
  }
}
