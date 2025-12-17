import 'package:equatable/equatable.dart';

class VideoModel extends Equatable {
  final int id;
  final String title;
  final int teacher;
  final int? course;
  final String videoUrl;
  final String thumbnail;
  final String duration;

  const VideoModel({
    required this.id,
    required this.title,
    required this.teacher,
    this.course,
    this.videoUrl = "",
    this.thumbnail = "",
    this.duration = "00:00",
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: json["id"],
    title: json["title"],
    teacher: json["teacher"],
    course: json["course"],
    videoUrl: json["video_url"] ?? "",
    thumbnail: json["thumbnail"] ?? "",
    duration: json["duration"] ?? "00:00",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "teacher": teacher,
    "course": course,
    "video_url": videoUrl,
    "thumbnail": thumbnail,
    "duration": duration,
  };

  @override
  List<Object> get props {
    return [id, title, teacher, videoUrl, thumbnail, duration];
  }
}
