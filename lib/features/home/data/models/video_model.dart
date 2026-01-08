import 'package:equatable/equatable.dart';

class VideoModel extends Equatable {
  final int id;
  final String title;
  final bool isLocked;
  // final String teacher;
  final String? course;
  final String videoUrl;
  final String thumbnail;
  final String duration;

  const VideoModel({
    required this.id,
    required this.title,
    // required this.teacher,
    this.course,
    this.videoUrl = "",
    this.thumbnail = "",
    this.duration = "00:00",
    required this.isLocked,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: json["id"],
    title: json["title"],
    // teacher: json["teacher"],
    course: json["course"],
    videoUrl: json["video_url"] ?? "",
    thumbnail: json["thumbnail"] ?? "",
    duration: json["duration"] ?? "00:00",
    isLocked: json["isLocked"] ?? true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    // "teacher": teacher,
    "course": course,
    "video_url": videoUrl,
    "thumbnail": thumbnail,
    "duration": duration,
    "isLocked": isLocked,
  };

  @override
  List<Object> get props {
    return [id, title, videoUrl, thumbnail, duration, isLocked];
  }
}
