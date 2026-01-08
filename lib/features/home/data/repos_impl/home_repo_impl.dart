import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/class_model.dart';

import 'package:durbar_physics/features/home/data/models/stream_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/domain/repos/home_repo.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final ApiClient apiClient;

  HomeRepoImpl(this.apiClient);

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await apiClient.request(
      path: 'course/',
      method: ApiMethod.get,
    );
    return (response as List).map((e) => CourseModel.fromJson(e)).toList();
  }

  @override
  Future<List<ClassModel>> getClasses() async {
    final response = await apiClient.request(
      path: '/classes/',
      method: ApiMethod.get,
    );
    return (response as List).map((e) => ClassModel.fromJson(e)).toList();
  }

  @override
  Future<List<StreamModel>> getStreams() async {
    final response = await apiClient.request(
      path: '/streams/',
      method: ApiMethod.get,
    );
    return (response as List).map((e) => StreamModel.fromJson(e)).toList();
  }

  @override
  Future<List<VideoModel>> getVideos() async {
    final response = await apiClient.request(
      path: '/videos/',
      method: ApiMethod.get,
    );
    return (response as List).map((e) => VideoModel.fromJson(e)).toList();
  }

  @override
  Future<CourseDetailModel> getCourseDetail(int id) async {
    final response = await apiClient.request(
      path: 'course/$id/',
      method: ApiMethod.get,
    );

    return CourseDetailModel.fromJson(response);
  }
}
