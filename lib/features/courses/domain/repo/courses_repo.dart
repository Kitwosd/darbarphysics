import 'package:durbar_physics/features/courses/data/model/banner_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';

abstract class CoursesRepo {
  Future<List<CourseModel>> getEnrolledCourses();
  Future<List<BannerModel>> getBannerItems();
}
