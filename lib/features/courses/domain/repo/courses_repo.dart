import 'package:durbar_physics/features/courses/data/model/course_model.dart';

abstract class CoursesRepo {
  Future<List<CourseModel>> getEnrolledCourses();
}
