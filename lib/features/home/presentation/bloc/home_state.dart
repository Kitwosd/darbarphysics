part of 'home_bloc.dart';



class HomeState extends Equatable {
  final List<CourseModel> courses;
  final List<ClassModel> classes;
  final List<StreamModel> streams;
  final List<LiveClassModel> liveClasses;
  final List<VideoModel> videos;
  final String error;
  final ApiDataStatus status;

  const HomeState({
    this.courses = const [],
    this.classes = const [],
    this.streams = const [],
    this.liveClasses = const [],
    this.videos = const [],
    this.error = '',
    this.status = ApiDataStatus.initial,
  });

  HomeState copyWith({
    List<CourseModel>? courses,
    List<ClassModel>? classes,
    List<StreamModel>? streams,
    List<LiveClassModel>? liveClasses,
    List<VideoModel>? videos,
    String? error,
    ApiDataStatus? status,
  }) {
    return HomeState(
      courses: courses ?? this.courses,
      classes: classes ?? this.classes,
      streams: streams ?? this.streams,
      liveClasses: liveClasses ?? this.liveClasses,
      videos: videos ?? this.videos,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    courses,
    classes,
    streams,
    liveClasses,
    videos,
    error,
    status,
  ];
}
