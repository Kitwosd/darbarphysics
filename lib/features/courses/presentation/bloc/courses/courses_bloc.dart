import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';

import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';

import 'package:injectable/injectable.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@injectable
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final HomeRepo repo;
  CoursesBloc(this.repo) : super(CoursesState()) {
    on<GetCoursesEvent>(_onGetCoursesEvent);
    on<GetCourseDetailEvent>(_onGetCourseDetailEvent);
    on<CourseLoadMoreEvent>(_onCourseLoadMoreEvent);
  }

  FutureOr<void> _onGetCoursesEvent(
    CoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final courses = await repo.getCourses(page: 1);

      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          coursesList: courses.results,
          currentPage: 2,
          hasReachedMax: courses.next == null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error, error: e.toString()));
      logger.e('This is the error: ${e.toString()}');
    }
  }

  FutureOr<void> _onGetCourseDetailEvent(
    GetCourseDetailEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(courseDetailStatus: ApiDataStatus.loading));

    try {
      final courseDetail = await repo.getCourseDetail(event.courseId);

      emit(
        state.copyWith(
          courseDetailStatus: ApiDataStatus.success,
          course: courseDetail,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          courseDetailStatus: ApiDataStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onCourseLoadMoreEvent(
    CourseLoadMoreEvent event,
    Emitter<CoursesState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final response = await repo.getCourses(page: state.currentPage);

      //append new items
      final updatedList = List.of(state.coursesList)..addAll(response.results);

      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          coursesList: updatedList,

          //check if the next is null to know if we have reached the end
          hasReachedMax: response.next == null,
          currentPage: state.currentPage + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error));
    }
  }
}
