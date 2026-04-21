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

class CourseLoadMoreEvent extends CoursesEvent {}

enum CourseSortOrder { newest, priceLowToHigh, priceHighToLow, mostPopular }

class ChangeCourseSortEvent extends CoursesEvent {
  final CourseSortOrder sortOrder;
  const ChangeCourseSortEvent(this.sortOrder);
  @override
  List<Object> get props => [sortOrder];
}
