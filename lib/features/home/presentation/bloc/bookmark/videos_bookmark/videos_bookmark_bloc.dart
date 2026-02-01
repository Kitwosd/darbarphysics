// ignore_for_file: unused_import

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:durbar_physics/core/hive_services/hive_mappers/video_mapper.dart';
import 'package:durbar_physics/core/hive_services/hive_services.dart';
import 'package:durbar_physics/core/hive_services/services/hive_video_service.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'videos_bookmark_event.dart';
part 'videos_bookmark_state.dart';

@lazySingleton
class VideosBookmarkBloc
    extends Bloc<VideosBookmarkEvent, VideosBookmarkState> {
  HiveVideoService hiveServices;
  VideosBookmarkBloc(this.hiveServices) : super(VideosBookmarkState()) {
    on<AddVideoEvent>(_onAddVideoEvent);
    on<RemoveVideoEvent>(_onRemoveVideoEvent);
    on<LoadVideosEvent>(_onLoadVideosEvent);
  }

  FutureOr<void> _onAddVideoEvent(
    AddVideoEvent event,
    Emitter<VideosBookmarkState> emit,
  ) async {
    await hiveServices.addVideo(event.video.toHive());
    final list = hiveServices.getAllVideos();
    final videos = list.map((e) => e.toVideo()).toList();
    final ids = list.map((e) => e.id).toSet();

    emit(state.copyWith(videoIds: ids, videos: videos));
  }

  FutureOr<void> _onRemoveVideoEvent(
    RemoveVideoEvent event,
    Emitter<VideosBookmarkState> emit,
  ) async {
    await hiveServices.removeVideo(event.videoId);
    final list = hiveServices.getAllVideos();
    final videos = list.map((e) => e.toVideo()).toList();
    final ids = list.map((e) => e.id).toSet();

    emit(state.copyWith(videoIds: ids, videos: videos));
  }

  FutureOr<void> _onLoadVideosEvent(
    LoadVideosEvent event,
    Emitter<VideosBookmarkState> emit,
  ) {
    try {
      final list = hiveServices.getAllVideos();
      final videos = list.map((e) => e.toVideo()).toList();
      final ids = list.map((e) => e.id).toSet();
      logger.d('Loaded: ${videos.length} videos from the hive');
      emit(state.copyWith(videoIds: ids, videos: videos));
    } catch (e, stackTrace) {
      logger.e(
        'Failed to load videos from hive',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(videoIds: {}, videos: []));
    }
  }
}
