part of 'live_classes_bloc.dart';

class LiveClassesState extends Equatable {
  final List<LiveClassModel> liveClasses;
  final LiveClassDetailModel? liveClassDetail;
  final ApiDataStatus status;
  final ApiDataStatus liveClassDetailStatus;
  final String error;
  final String liveClassDetailError;

  const LiveClassesState({
    this.liveClasses = const [],
    this.status = ApiDataStatus.initial,
    this.error = '',
    this.liveClassDetail,
    this.liveClassDetailStatus = ApiDataStatus.initial,
    this.liveClassDetailError = '',
  });

  LiveClassesState copyWith({
    List<LiveClassModel>? liveClasses,
    ApiDataStatus? status,
    String? error,
    LiveClassDetailModel? liveClassDetail,
    ApiDataStatus? liveClassDetailStatus,
    String? liveClassDetailError,
  }) {
    return LiveClassesState(
      liveClasses: liveClasses ?? this.liveClasses,
      status: status ?? this.status,
      error: error ?? this.error,
      liveClassDetail: liveClassDetail ?? this.liveClassDetail,
      liveClassDetailStatus:
          liveClassDetailStatus ?? this.liveClassDetailStatus,
      liveClassDetailError: liveClassDetailError ?? this.liveClassDetailError,
    );
  }

  @override
  List<Object?> get props => [
    liveClasses,
    status,
    error,
    liveClassDetailStatus,
    liveClassDetailError,
  ];
}
