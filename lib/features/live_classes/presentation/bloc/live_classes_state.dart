part of 'live_classes_bloc.dart';

class LiveClassesState extends Equatable {
  final List<LiveClassModel> liveClasses;
  final LiveClassDetailModel? liveClassDetail;
  final ApiDataStatus status;
  final String? error;

  const LiveClassesState({
    this.liveClasses = const [],
    this.status = ApiDataStatus.initial,
    this.error,
    this.liveClassDetail,
  });

  LiveClassesState copyWith({
    List<LiveClassModel>? liveClasses,
    ApiDataStatus? status,
    String? error,
    LiveClassDetailModel? liveClassDetail,
  }) {
    return LiveClassesState(
      liveClasses: liveClasses ?? this.liveClasses,
      status: status ?? this.status,
      error: error,
      liveClassDetail: liveClassDetail ?? this.liveClassDetail,
    );
  }

  @override
  List<Object?> get props => [liveClasses, status, error];
}
