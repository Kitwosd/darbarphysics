import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:equatable/equatable.dart';

class CourseBookmarkState extends Equatable {
  final List<CourseModel> courses;
  final Set<int> bookmarkIds;
  // final CourseModel? course;
  // final bool isCourseBookmarked;
  const CourseBookmarkState({
    this.courses = const [],
    this.bookmarkIds = const {},
    // this.course,
    // this.isCourseBookmarked = false,
  });

  CourseBookmarkState copyWith({
    List<CourseModel>? courses,
    Set<int>? bookmarkIds,
    // bool? isCourseBookmarked,
    // CourseModel? course,
  }) {
    return CourseBookmarkState(
      courses: courses ?? this.courses,
      bookmarkIds: bookmarkIds ?? this.bookmarkIds,
      // isCourseBookmarked: isCourseBookmarked ?? this.isCourseBookmarked,
      // course: course ?? this.course,
    );
  }

  @override
  List<Object> get props => [courses, bookmarkIds];
}
