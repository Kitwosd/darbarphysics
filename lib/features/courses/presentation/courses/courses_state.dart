part of 'courses_bloc.dart';

class CoursesState extends Equatable {
  final List<CourseModel> coursesList;
  final ApiDataStatus status;
  final String error;
  final CourseDetailModel? course;
  final ApiDataStatus courseDetailStatus;

  const CoursesState({
    this.coursesList = const [],
    this.status = ApiDataStatus.initial,
    this.error = '',
    this.course,
    this.courseDetailStatus = ApiDataStatus.initial,
  });

  CoursesState copyWith({
    List<CourseModel>? coursesList,
    ApiDataStatus? status,
    String? error,
    CourseDetailModel? course,
    ApiDataStatus? courseDetailStatus,
  }) {
    return CoursesState(
      coursesList: coursesList ?? this.coursesList,
      status: status ?? this.status,
      error: error ?? this.error,
      course: course ?? this.course,
      courseDetailStatus: courseDetailStatus ?? this.courseDetailStatus,
    );
  }

  @override
  List<Object?> get props => [coursesList, status, error, course, courseDetailStatus];
}
