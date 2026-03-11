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
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final baseUrl = dotenv.env['BASE_THUMBNAIL_URL'];
    String thumbnailPath = json['thumbnail'] ?? '';
    if (thumbnailPath.isNotEmpty && !thumbnailPath.startsWith('http')) {
      thumbnailPath = '$baseUrl$thumbnailPath';
    }
    return VideoModel(
      id: json["id"],
      title: json["title"],
      // teacher: json["teacher"],
      course: json["course"],
      // videoUrl: 'https://www.youtube.com/watch?v=K5KVEU3aaeQ',

      //TODO: remove the url mathi ko get the url from the backend only
      videoUrl: json["videoUrl"] ?? "",
      thumbnail: thumbnailPath,
      duration: json["duration"] ?? "00:00",
      isLocked: json["isLocked"] ?? true,
      isUserLocked: json["is_user_locked"] ?? true,
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
  List<Object> get props {
    return [id, title, videoUrl, duration, isLocked, isUserLocked];
  }
}
