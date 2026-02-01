import 'package:durbar_physics/core/hive_services/hive_models/course_hive_model.dart';
import 'package:hive/hive.dart';

import 'package:injectable/injectable.dart';

@lazySingleton
class HiveCourseService {
  final Box<CourseHiveModel> box = Hive.box<CourseHiveModel>('courseBox');

  // Save/Bookmark the course
  Future<void> saveCourse(CourseHiveModel course) async {
    await box.put(course.id, course);
  }

  //remove the bookmark
  Future<void> removeCourse(int courseId) async {
    await box.delete(courseId);
  }

  //check if bookmarked
  bool isBookmarked(int courseId) {
    return box.containsKey(courseId);
  }

  //Get all bookmarked courses
  List<CourseHiveModel> getAllCourses() {
    return box.values.toList();
  }

  // clear on logout
  Future<void> clearAll() async {
    await box.clear();
  }
}
