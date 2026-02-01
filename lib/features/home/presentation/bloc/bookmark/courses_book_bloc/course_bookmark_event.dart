part of 'course_bookmark_bloc.dart';

sealed class CourseBookmarkEvent extends Equatable {
  const CourseBookmarkEvent();

  @override
  List<Object> get props => [];
}

class AddCourseEvent extends CourseBookmarkEvent {
  final CourseModel course;
  const AddCourseEvent({required this.course});
}

class LoadBookmarkCoursesEvent extends CourseBookmarkEvent {}

class RemoveCourseEvent extends CourseBookmarkEvent {
  final int courseId;
  const RemoveCourseEvent({required this.courseId});
}

class CheckBookmarkStatus extends CourseBookmarkEvent {
  final int courseId;
  const CheckBookmarkStatus({required this.courseId});
}

class ResetBookmarkToastResultEvent extends CourseBookmarkEvent {}
