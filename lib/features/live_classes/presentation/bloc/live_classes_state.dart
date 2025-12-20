part of 'live_classes_bloc.dart';

class LiveClassesState extends Equatable {
  final List<LiveClassModel> liveClasses;
  final ApiDataStatus status;
  final String? error;

  const LiveClassesState({
    this.liveClasses = const [],
    this.status = ApiDataStatus.initial,
    this.error,
  });

  LiveClassesState copyWith({
    List<LiveClassModel>? liveClasses,
    ApiDataStatus? status,
    String? error,
  }) {
    return LiveClassesState(
      liveClasses: liveClasses ?? this.liveClasses,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [liveClasses, status, error];
}
