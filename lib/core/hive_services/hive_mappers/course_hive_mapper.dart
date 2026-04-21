import 'package:durbar_physics/core/hive_services/hive_models/course_hive_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';

extension CourseToHive on CourseModel {
  CourseHiveModel toHive() => CourseHiveModel(
    id: id,
    title: title,
    description: description,
    cost: cost.toString(),
    image: image,
    rating: rating,
    studentCount: studentCount,
    lessonCount: lessonCount,
    liveClassCount: liveClassCount,
    isUserLocked: isUserLocked,

    // ✅ NEW
    levelName: levelName,
    subjectName: subjectName,
  );
}

extension HiveToCourse on CourseHiveModel {
  CourseModel toCourse() => CourseModel(
    id: id,
    title: title,
    description: description,
    cost: cost,
    image: image,
    rating: rating,
    studentCount: studentCount,
    lessonCount: lessonCount,
    liveClassCount: liveClassCount,
    isUserLocked: isUserLocked,

    // ✅ NEW
    levelName: levelName,
    subjectName: subjectName,

    streams: [],
    streamNames: [],
  );
}

//you maile courseModel base ma banaye so to rectify that as bookmark is in courseDetailModel we have this
extension CourseDetailToHive on CourseDetailModel {
  CourseHiveModel toHive() => CourseHiveModel(
    id: id,
    title: title,
    description: description,
    cost: cost,
    image: image,
    rating: rating,
    studentCount: studentCount,
    lessonCount: lessonCount,
    liveClassCount: liveClassCount,
    isUserLocked: isUserLocked,

    // ✅ NEW
    levelName: levelName,
    subjectName: subjectName,
  );
}
