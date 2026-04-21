part of 'videos_bloc.dart';

sealed class VideosEvent extends Equatable {
  const VideosEvent();

  @override
  List<Object> get props => [];
}

class GetVideosEvent extends VideosEvent {}

class LoadMoreVideosEvent extends VideosEvent{}
