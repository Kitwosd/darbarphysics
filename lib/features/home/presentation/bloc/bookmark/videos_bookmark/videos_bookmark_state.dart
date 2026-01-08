part of 'videos_bookmark_bloc.dart';

class VideosBookmarkState extends Equatable {
  final List<VideoModel> videos;
  final Set<int> videoIds;

  const VideosBookmarkState({this.videoIds = const {}, this.videos = const []});

  VideosBookmarkState copyWith({List<VideoModel>? videos, Set<int>? videoIds}) {
    return VideosBookmarkState(
      videoIds: videoIds ?? this.videoIds,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object> get props => [videos, videoIds];
}
