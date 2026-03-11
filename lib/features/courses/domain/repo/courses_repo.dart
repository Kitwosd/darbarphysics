import 'package:durbar_physics/core/network/paginated_response_model.dart';
import 'package:durbar_physics/features/courses/data/model/banner_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/post_review_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/review_model.dart';

abstract class CoursesRepo {
  Future<List<CourseModel>> getEnrolledCourses();
  Future<List<BannerModel>> getBannerItems();
  Future<PaginatedResponseModel<ReviewModel>> getReviews(
    int courseId, {
    int page = 1,
  });
  Future<String> postReview(PostReviewModel model);
}
