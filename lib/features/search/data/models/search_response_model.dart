import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';

class SearchResponseModel {
  final List<CourseModel> courses;
  final List<LiveClassModel> liveClasses;
  final List<VideoModel> videos;

  const SearchResponseModel({
    required this.courses,
    required this.liveClasses,
    required this.videos,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      courses: (json['courses'] as List)
          .map((c) => CourseModel.fromJson(c))
          .toList(),
      liveClasses: (json['live_classes'] as List)
          .map((c) => LiveClassModel.fromJson(c))
          .toList(),
      videos: (json['videos'] as List)
          .map((c) => VideoModel.fromJson(c))
          .toList(),
    );
  }
}
