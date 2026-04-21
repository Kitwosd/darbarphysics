import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/domain/repos/home_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'videos_event.dart';
part 'videos_state.dart';

@injectable
class VideosBloc extends Bloc<VideosEvent, VideosState> {
  HomeRepo repo;
  VideosBloc(this.repo) : super(VideosState()) {
    on<GetVideosEvent>(_onGetVideosEvent);
    on<LoadMoreVideosEvent>(_onLoadMoreVideosEvent);
  }

  FutureOr<void> _onGetVideosEvent(
    GetVideosEvent event,
    Emitter<VideosState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final videos = await repo.getVideos(page: 1);
      emit(
        state.copyWith(
          status: ApiDataStatus.success,
          videos: videos.results,
          page: state.page + 1,
          hasReachedMax: videos.next == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          error: 'Error during fetching the videos: ${e.toString()}',
        ),
      );
    }
  }

  FutureOr<void> _onLoadMoreVideosEvent(
    LoadMoreVideosEvent event,
    Emitter<VideosState> emit,
  ) async {
    try {
      final response = await repo.getVideos(page: state.page);
      final updatedList = List.of(state.videos)..addAll(response.results);
      emit(
        state.copyWith(
          videos: updatedList,
          page: state.page + 1,
          status: ApiDataStatus.success,
          hasReachedMax: response.next == null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ApiDataStatus.error,
          error: 'Something wrong happened during loading more videos',
        ),
      );
    }
  }
}
