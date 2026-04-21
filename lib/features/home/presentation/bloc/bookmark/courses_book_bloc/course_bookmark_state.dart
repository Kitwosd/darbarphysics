// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:equatable/equatable.dart';

class CourseBookmarkState extends Equatable {
  final List<CourseModel> courses;
  final Set<int> bookmarkIds;
  final bool showToast;
  final bool wasAdded;
  // final CourseModel? course;
  // final bool isCourseBookmarked;
  const CourseBookmarkState({
    // this.course,
    // this.isCourseBookmarked = false,
    this.courses = const [],
    this.bookmarkIds = const {},
    this.showToast = false,
    this.wasAdded = false,
  });

  CourseBookmarkState copyWith({
    List<CourseModel>? courses,
    Set<int>? bookmarkIds,
    bool? showToast,
    bool? wasAdded,
    // bool? isCourseBookmarked,
    // CourseModel? course,
  }) {
    return CourseBookmarkState(
      courses: courses ?? this.courses,
      bookmarkIds: bookmarkIds ?? this.bookmarkIds,
      showToast: showToast ?? this.showToast,
      wasAdded: wasAdded ?? this.wasAdded,
      // isCourseBookmarked: isCourseBookmarked ?? this.isCourseBookmarked,
      // course: course ?? this.course,
    );
  }

  @override
  List<Object> get props => [courses, bookmarkIds, showToast, wasAdded];
}
