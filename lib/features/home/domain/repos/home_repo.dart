import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/class_model.dart';

import 'package:durbar_physics/features/home/data/models/stream_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';

abstract class HomeRepo {
  Future<List<CourseModel>> getCourses();
  Future<CourseDetailModel> getCourseDetail(int id);
  Future<List<ClassModel>> getClasses();
  Future<List<StreamModel>> getStreams();
  Future<List<VideoModel>> getVideos();
}
