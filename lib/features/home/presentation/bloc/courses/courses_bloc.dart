import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dubar_physics/common/enums/enums.dart';
import 'package:dubar_physics/core/network/api_client.dart';
import 'package:dubar_physics/features/home/data/models/course_model.dart';
import 'package:dubar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@injectable
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final HomeRepo repo;
  CoursesBloc(this.repo) : super(CoursesState()) {
    on<CoursesEvent>(_onCoursesEvent);
  }

  FutureOr<void> _onCoursesEvent(
    CoursesEvent event,
    Emitter<CoursesState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final courses = await repo.getCourses();
      
      emit(state.copyWith(courses: courses));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
