part of 'live_classes_bloc.dart';

class LiveClassesState extends Equatable {
  final List<LiveClassModel> liveClasses;
  final LiveClassDetailModel? liveClassDetail;
  final ApiDataStatus status;
  final ApiDataStatus liveClassDetailStatus;
  final String error;
  final String liveClassDetailError;
  final int currentPage;
  final bool hasReachedMax;

  const LiveClassesState({
    this.liveClasses = const [],
    this.status = ApiDataStatus.initial,
    this.error = '',
    this.liveClassDetail,
    this.liveClassDetailStatus = ApiDataStatus.initial,
    this.liveClassDetailError = '',
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  LiveClassesState copyWith({
    List<LiveClassModel>? liveClasses,
    ApiDataStatus? status,
    String? error,
    LiveClassDetailModel? liveClassDetail,
    ApiDataStatus? liveClassDetailStatus,
    String? liveClassDetailError,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return LiveClassesState(
      liveClasses: liveClasses ?? this.liveClasses,
      status: status ?? this.status,
      error: error ?? this.error,
      liveClassDetail: liveClassDetail ?? this.liveClassDetail,
      liveClassDetailStatus:
          liveClassDetailStatus ?? this.liveClassDetailStatus,
      liveClassDetailError: liveClassDetailError ?? this.liveClassDetailError,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    liveClasses,
    status,
    error,
    liveClassDetailStatus,
    liveClassDetailError,
    currentPage,
    hasReachedMax,
  ];
}
