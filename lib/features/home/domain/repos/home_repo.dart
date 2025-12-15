import 'package:dubar_physics/features/home/data/models/class_model.dart';
import 'package:dubar_physics/features/courses/data/model/course_model.dart';
import 'package:dubar_physics/features/home/data/models/live_class_model.dart';
import 'package:dubar_physics/features/home/data/models/stream_model.dart';
import 'package:dubar_physics/features/home/data/models/video_model.dart';

abstract class HomeRepo {
  Future<List<CourseModel>> getCourses();
  Future<List<ClassModel>> getClasses();
  Future<List<StreamModel>> getStreams();
  Future<List<LiveClassModel>> getLiveClasses();
  Future<List<VideoModel>> getVideos();
}
