import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/search/domain/repo/search_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepo repo;
  SearchBloc(this.repo) : super(SearchState()) {
    on<GetSearchedDataEvent>(_onGetSearchedDataEvent);
  }

  FutureOr<void> _onGetSearchedDataEvent(
    GetSearchedDataEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final response = await repo.search(event.query);

      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          courses: response.courses,
          videos: response.videos,
          liveClasses: response.liveClasses,
          query: event.query,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Some Error Occured: ${e.toString}',
          status: ApiDataStatus.error,
        ),
      );
    }
  }
}
