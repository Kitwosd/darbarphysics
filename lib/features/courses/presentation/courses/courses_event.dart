part of 'courses_bloc.dart';

sealed class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object> get props => [];
}

class GetCoursesEvent extends CoursesEvent {}

class GetCourseDetailEvent extends CoursesEvent {
  final int courseId;
  const GetCourseDetailEvent({required this.courseId});
}
