part of 'enrolled_courses_bloc.dart';

class EnrolledCoursesState extends Equatable {
  final List<CourseModel> enrolledCourses;
  final ApiDataStatus status;
  final String errorMessage;
  const EnrolledCoursesState({
    this.enrolledCourses = const [],
    this.status = ApiDataStatus.initial,
    this.errorMessage = '',
  });

  EnrolledCoursesState copyWith({
    List<CourseModel>? enrolledCourses,
    ApiDataStatus? status,
    String? errorMessage,
  }) {
    return EnrolledCoursesState(
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [enrolledCourses, status, errorMessage];
}
