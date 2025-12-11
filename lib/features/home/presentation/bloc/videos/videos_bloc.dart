import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dubar_physics/common/enums/enums.dart';
import 'package:dubar_physics/core/network/api_client.dart';
import 'package:dubar_physics/features/home/data/models/video_model.dart';
import 'package:equatable/equatable.dart';

part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  ApiClient apiClient;
  VideosBloc(this.apiClient) : super(VideosState()) {
    on<GetVideosEvent>(_onGetVideosEvent);
  }

  FutureOr<void> _onGetVideosEvent(
    GetVideosEvent event,
    Emitter<VideosState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ApiDataStatus.loading));
      final videos = await apiClient.request(
        path: '/vidoes/',
        method: ApiMethod.get,
      );
      emit(state.copyWith(status: ApiDataStatus.success, videos: videos));
    } catch (e) {}
  }
}
