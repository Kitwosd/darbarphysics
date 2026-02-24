import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/paginated_response_model.dart';
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
  Future<PaginatedResponseModel<VideoModel>> getVideos({int page = 1}) async {
    final response = await apiClient.request(
      path: 'lessons/',
      method: ApiMethod.get,
      queryParameters: {'page': page},
    );
    return PaginatedResponseModel<VideoModel>.fromJson(
      response,
      (json) => VideoModel.fromJson(json),
    );
  }

  @override
  Future<CourseDetailModel> getCourseDetail(int id) async {
    final response = await apiClient.request(
      path: 'course/$id/',
      method: ApiMethod.get,
    );

    return CourseDetailModel.fromJson(response);
  }

  @override
  Future<PaginatedResponseModel<CourseModel>> getCourses({int page = 1}) async {
    final response = await apiClient.request(
      path: 'course/',
      method: ApiMethod.get,
      queryParameters: {'page': page},
    );

    return PaginatedResponseModel.fromJson(
      response,
      (json) => CourseModel.fromJson(json),
    );
  }
}
