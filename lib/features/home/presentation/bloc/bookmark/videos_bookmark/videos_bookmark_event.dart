part of 'videos_bookmark_bloc.dart';

sealed class VideosBookmarkEvent extends Equatable {
  const VideosBookmarkEvent();

  @override
  List<Object> get props => [];
}

class AddVideoEvent extends VideosBookmarkEvent {
  final VideoModel video;
  const AddVideoEvent({required this.video});
}

class RemoveVideoEvent extends VideosBookmarkEvent {
  final int videoId;
  const RemoveVideoEvent({required this.videoId});
}

class LoadVideosEvent extends VideosBookmarkEvent {}

// ADDED: clear state event
class ClearAllVideosBookmarkEvent extends VideosBookmarkEvent {}
