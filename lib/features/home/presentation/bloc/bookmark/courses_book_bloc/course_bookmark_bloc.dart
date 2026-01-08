import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/core/hive_services/hive_mappers/course_hive_mapper.dart';
import 'package:durbar_physics/core/hive_services/hive_models/course_hive_model.dart';
import 'package:durbar_physics/core/hive_services/services/hive_course_service.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_state.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'course_bookmark_event.dart';

@lazySingleton
class CourseBookmarkBloc
    extends Bloc<CourseBookmarkEvent, CourseBookmarkState> {
  HiveCourseService hiveService;
  CourseBookmarkBloc(this.hiveService) : super(CourseBookmarkState()) {
    on<AddCourseEvent>(_onAddCourseEvent);
    on<RemoveCourseEvent>(_onRemoveCourseEvent);
    on<LoadBookmarkCoursesEvent>(_onLoadBookmarkCoursesEvent);
    on<CheckBookmarkStatus>(_onCheckBookmarkStatus);
  }

  FutureOr<void> _onAddCourseEvent(
    AddCourseEvent event,
    Emitter<CourseBookmarkState> emit,
  ) async {
    await hiveService.saveCourse(event.course.toHive());
    final list = hiveService.getAllCourses();
    final courses = list.map((e) => e.toCourse()).toList();

    final ids = list.map((e) => e.id).toSet();
    emit(state.copyWith(courses: courses, bookmarkIds: ids));
  }

  FutureOr<void> _onRemoveCourseEvent(
    RemoveCourseEvent event,
    Emitter<CourseBookmarkState> emit,
  ) async {
    await hiveService.removeCourse(event.courseId);
    final list = hiveService.getAllCourses();
    final courses = list.map((e) => e.toCourse()).toList();
    final ids = list.map((e) => e.id).toSet();
    emit(state.copyWith(courses: courses, bookmarkIds: ids));
  }

  FutureOr<void> _onLoadBookmarkCoursesEvent(
    LoadBookmarkCoursesEvent event,
    Emitter<CourseBookmarkState> emit,
  ) {
    final List<CourseHiveModel> list = hiveService.getAllCourses();
    final List<CourseModel> courses = list.map((e) => e.toCourse()).toList();
    final ids = list.map((e) => e.id).toSet();
    emit(state.copyWith(courses: courses, bookmarkIds: ids));
  }

  FutureOr<void> _onCheckBookmarkStatus(
    CheckBookmarkStatus event,
    Emitter<CourseBookmarkState> emit,
  ) {
    bool status = hiveService.isBookmarked(event.courseId);
  }

  bool isBookmarked(int courseId) {
    return state.courses.any((courses) => courses.id == courseId);
  }
}
