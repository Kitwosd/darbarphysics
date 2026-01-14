part of 'search_bloc.dart';

class SearchState extends Equatable {
  // final SearchResponseModel? searchResult;
  final List<CourseModel> courses;
  final List<LiveClassModel> liveClasses;
  final List<VideoModel> videos;
  final ApiDataStatus status;
  final String errorMessage;
  final String query;

  const SearchState({
    this.status = ApiDataStatus.initial,
    this.errorMessage = '',
    this.query = '',
    this.courses = const [],
    this.liveClasses = const [],
    this.videos = const [],
    // required searchResult,
  });

  SearchState copyWith({
    List<CourseModel>? courses,
    List<LiveClassModel>? liveClasses,
    List<VideoModel>? videos,

    ApiDataStatus? status,
    String? errorMessage,
    String? query,
  }) {
    return SearchState(
      courses: courses ?? this.courses,
      liveClasses: liveClasses ?? this.liveClasses,
      videos: videos ?? this.videos,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      query: query ?? this.query,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, query,liveClasses, videos, courses];
}
