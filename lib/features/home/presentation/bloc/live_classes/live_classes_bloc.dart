import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/home/data/models/live_class_model.dart';
import 'package:durbar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'live_classes_event.dart';
part 'live_classes_state.dart';

@injectable
class LiveClassesBloc extends Bloc<LiveClassesEvent, LiveClassesState> {
  final HomeRepo repo;
  LiveClassesBloc(this.repo) : super(LiveClassesState()) {
    on<LiveClassesEvent>(_onLiveClassesEvent);
  }

  FutureOr<void> _onLiveClassesEvent(
    LiveClassesEvent event,
    Emitter<LiveClassesState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final liveClasses = await repo.getLiveClasses();
      emit(
        state.copyWith(status: ApiDataStatus.success, liveClasses: liveClasses),
      );
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error, error: e.toString()));
    }
  }
}
