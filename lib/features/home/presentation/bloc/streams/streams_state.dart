part of 'streams_bloc.dart';

class StreamsState extends Equatable {
  final String error;
  final ApiDataStatus status;
  final List<StreamModel> streams;

  const StreamsState({
    this.error = '',
    this.status = ApiDataStatus.initial,
    this.streams = const [],
  });

  StreamsState copyWith({
    String? error,
    ApiDataStatus? status,
    List<StreamModel>? streams,
  }) {
    return StreamsState(
      error: error ?? this.error,
      status: status ?? this.status,
      streams: streams ?? this.streams,
    );
  }

  @override
  List<Object?> get props => [error, status, streams];
}
