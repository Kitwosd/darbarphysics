import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';

import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/courses/domain/repo/courses_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'enrolled_courses_event.dart';
part 'enrolled_courses_state.dart';

@Injectable()
class EnrolledCoursesBloc
    extends Bloc<EnrolledCoursesEvent, EnrolledCoursesState> {
  CoursesRepo repo;
  EnrolledCoursesBloc(this.repo) : super(EnrolledCoursesState()) {
    on<GetEnrolledCoursesEvent>(_onGetEnrolledCoursesEvent);
  }

  FutureOr<void> _onGetEnrolledCoursesEvent(
    GetEnrolledCoursesEvent event,
    Emitter<EnrolledCoursesState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final data = await repo.getEnrolledCourses();
      emit(
        state.copyWith(enrolledCourses: data, status: ApiDataStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          errorMessage:
              'Something Wrong happened during fetching: ERROR: ${e.toString()}',
        ),
      );
    }
  }
}
