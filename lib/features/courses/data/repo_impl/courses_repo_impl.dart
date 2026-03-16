import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/core/network/paginated_response_model.dart';
import 'package:durbar_physics/features/courses/data/model/banner_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/courses/data/model/document_model.dart';
import 'package:durbar_physics/features/courses/domain/repo/courses_repo.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/post_review_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/review_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CoursesRepo)
class CoursesRepoImpl implements CoursesRepo {
  final ApiClient apiClient;

  CoursesRepoImpl(this.apiClient);
  @override
  Future<List<CourseModel>> getEnrolledCourses() async {
    final response = await apiClient.request(
      path: 'my-courses/',
      method: ApiMethod.get,
    );
    return (response as List).map((e) => CourseModel.fromJson(e)).toList();
  }

  @override
  Future<List<BannerModel>> getBannerItems() async {
    final response = await apiClient.request(
      path: 'course-ads/',
      method: ApiMethod.get,
    );
    return (response as List).map((e) => BannerModel.fromJson(e)).toList();
  }

  @override
  Future<PaginatedResponseModel<ReviewModel>> getReviews(
    courseId, {
    int page = 1,
  }) async {
    final response = await apiClient.request(
      path: 'course/$courseId/reviews/',
      method: ApiMethod.get,
      queryParameters: {'page': page},
    );
    return PaginatedResponseModel<ReviewModel>.fromJson(
      response,
      (json) => ReviewModel.fromJson(json),
    );
  }

  @override
  Future<String> postReview(PostReviewModel model) async {
    final response = await apiClient.request(
      path: 'course-rate/',
      method: ApiMethod.post,
      data: model.toJson(),
    );
    return response['message']?.toString() ?? 'Sucessfully reviewed';
  }

  @override
  Future<PaginatedResponseModel<DocumentModel>> getDocuments(
    int courseId, {
    int page = 1,
  }) async {
    final response = await apiClient.request(
      path: 'course/$courseId/notes',
      method: ApiMethod.get,
      queryParameters: {'page': page},
    );

    return PaginatedResponseModel.fromJson(
      response,
      (json) => DocumentModel.fromJson(json),
    );
  }
}
