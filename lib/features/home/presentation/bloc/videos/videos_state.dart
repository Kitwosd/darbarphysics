part of 'videos_bloc.dart';

class VideosState extends Equatable {
  final String error;
  final ApiDataStatus status;
  final List<VideoModel> videos;

  const VideosState({
    this.error = '',
    this.status = ApiDataStatus.initial,
    this.videos = const [],
  });
  VideosState copyWith({
    String? error,
    ApiDataStatus? status,
    List<VideoModel>? videos,
  }) {
    return VideosState(
      error: error ?? this.error,
      status: status ?? this.status,
      videos: videos ?? this.videos,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [error, status, videos];
}
