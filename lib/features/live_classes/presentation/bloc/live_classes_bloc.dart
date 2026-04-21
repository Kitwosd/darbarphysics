import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/live_classes/domain/repos/live_classes_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'live_classes_event.dart';
part 'live_classes_state.dart';

@injectable
class LiveClassesBloc extends Bloc<LiveClassesEvent, LiveClassesState> {
  final LiveClassesRepo liveClassesRepo;

  LiveClassesBloc(this.liveClassesRepo) : super(const LiveClassesState()) {
    on<GetDetailLiveClassEvent>(_onGetDetailLiveClassEvent);
    on<GetLiveClassesEvent>(_onGetLiveClassesEvent);
    on<LoadMoreLiveClassEvent>(_onLoadMoreLiveClassEvent);
  }

  FutureOr<void> _onGetLiveClassesEvent(
    GetLiveClassesEvent event,
    Emitter<LiveClassesState> emit,
  ) async {
    emit(state.copyWith(status: ApiDataStatus.loading));
    try {
      final liveClasses = await liveClassesRepo.getLiveClasses(page: 1);

      emit(
        state.copyWith(
          liveClasses: liveClasses.results,
          status: ApiDataStatus.success,
          currentPage: state.currentPage + 1,
          hasReachedMax: liveClasses.next == null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error, error: e.toString()));
    }
  }

  FutureOr<void> _onGetDetailLiveClassEvent(
    GetDetailLiveClassEvent event,
    Emitter<LiveClassesState> emit,
  ) async {
    emit(state.copyWith(liveClassDetailStatus: ApiDataStatus.initial));
    try {
      final detail = await liveClassesRepo.getLiveClassDetail(event.id);
      emit(
        state.copyWith(
          liveClassDetail: detail,
          liveClassDetailStatus: ApiDataStatus.success,
        ),
      );
    } catch (e) {
      logger.d(e.toString());
      emit(
        state.copyWith(
          liveClassDetailStatus: ApiDataStatus.error,
          liveClassDetailError: 'Error during fetching \n Try Again Later',
        ),
      );
    }
  }

  FutureOr<void> _onLoadMoreLiveClassEvent(
    LoadMoreLiveClassEvent event,
    Emitter<LiveClassesState> emit,
  ) async {
    state.copyWith(status: ApiDataStatus.loading);
    try {
      final response = await liveClassesRepo.getLiveClasses(
        page: state.currentPage,
      );
      final updatedList = List.of(state.liveClasses)..addAll(response.results);
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          liveClasses: updatedList,
          currentPage: state.currentPage + 1,
          hasReachedMax: response.next == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          error:
              'Something we wrong at loading more event error: ${e.toString()}',
        ),
      );
    }
  }
}
