import 'package:durbar_physics/core/network/api_client.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/courses/domain/repo/courses_repo.dart';
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
}
