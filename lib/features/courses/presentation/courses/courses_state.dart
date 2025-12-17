part of 'courses_bloc.dart';

class CoursesState extends Equatable {
  final List<CourseModel> courses;
  final ApiDataStatus status;
  final String error;

  const CoursesState({
    this.courses = const [],
    this.status = ApiDataStatus.initial,
    this.error = '',
  });

  CoursesState copyWith({
    List<CourseModel>? courses,
    ApiDataStatus? status,
    String? error,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [courses, status, error];
}
