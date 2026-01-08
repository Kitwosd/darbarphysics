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

@lazySingleton
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final HomeRepo repo;
  CoursesBloc(this.repo) : super(CoursesState()) {
    on<GetCoursesEvent>(_onCoursesEvent);
    on<GetCourseDetailEvent>(_onGetCourseDetailEvent);
  }

  FutureOr<void> _onCoursesEvent(
    CoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final courses = await repo.getCourses();

      emit(state.copyWith(status: ApiDataStatus.success, coursesList: courses));
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error, error: e.toString()));
      logger.e(e.toString());
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

 
}
