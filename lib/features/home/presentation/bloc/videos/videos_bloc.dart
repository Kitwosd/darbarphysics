import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dubar_physics/common/enums/enums.dart';
import 'package:dubar_physics/features/home/data/models/video_model.dart';
import 'package:dubar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'videos_event.dart';
part 'videos_state.dart';

@injectable
class VideosBloc extends Bloc<VideosEvent, VideosState> {
  HomeRepo repo;
  VideosBloc(this.repo) : super(VideosState()) {
    on<GetVideosEvent>(_onGetVideosEvent);
  }

  FutureOr<void> _onGetVideosEvent(
    GetVideosEvent event,
    Emitter<VideosState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final videos = await repo.getVideos();
      emit(state.copyWith(status: ApiDataStatus.success, videos: videos));
    } catch (e) {
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          error: 'Error during fetching the videos: ${e.toString()}',
        ),
      );
    }
  }
}
