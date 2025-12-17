import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/home/data/models/stream_model.dart';
import 'package:durbar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'streams_event.dart';
part 'streams_state.dart';

@injectable
class StreamsBloc extends Bloc<StreamsEvent, StreamsState> {
  final HomeRepo repo;
  StreamsBloc(this.repo) : super(StreamsState()) {
    on<GetStreamsEvent>(_onGetStreamsEvent);
  }

  FutureOr<void> _onGetStreamsEvent(
    GetStreamsEvent event,
    Emitter<StreamsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final streams = await repo.getStreams();
      emit(state.copyWith(status: ApiDataStatus.success, streams: streams));
    } catch (e) {
      emit(state.copyWith(status: ApiDataStatus.error, error: e.toString()));
    }
  }
}
