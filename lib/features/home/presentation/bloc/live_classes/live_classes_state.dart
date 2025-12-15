part of 'live_classes_bloc.dart';

class LiveClassesState extends Equatable {
  final String error;
  final ApiDataStatus status;
  final List<LiveClassModel> liveClasses;
  const LiveClassesState({
    this.error = '',
    this.status = ApiDataStatus.initial,
    this.liveClasses = const [],
  });
  LiveClassesState copyWith({
    String? error,
    ApiDataStatus? status,
    List<LiveClassModel>? liveClasses,
  }) {
    return LiveClassesState(
      error: error ?? this.error,
      status: status ?? this.status,
      liveClasses: liveClasses ?? this.liveClasses,
    );
  }

  @override
  List<Object?> get props => [liveClasses, error, status];
}
