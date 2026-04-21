part of 'videos_bloc.dart';

class VideosState extends Equatable {
  final String error;
  final ApiDataStatus status;
  final List<VideoModel> videos;
  final int page;
  final bool hasReachedMax;

  const VideosState({
    this.error = '',
    this.status = ApiDataStatus.initial,
    this.videos = const [],
    this.page = 1,
    this.hasReachedMax = false,
  });
  VideosState copyWith({
    String? error,
    ApiDataStatus? status,
    List<VideoModel>? videos,
    int? page,
    bool? hasReachedMax,
  }) {
    return VideosState(
      error: error ?? this.error,
      status: status ?? this.status,
      videos: videos ?? this.videos,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [error, status, videos, page, hasReachedMax];
}
