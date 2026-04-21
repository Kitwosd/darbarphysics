part of 'zoom_bloc.dart';

enum ZoomStatus {
  initial,
  loading,
  success,
  error,
  connectivityError,
  meetingEnded,
}

class ZoomState extends Equatable {
  final ZoomStatus status;
  final String webUrl;
  final String errorMessage;
  final double progress;

  const ZoomState({
    this.status = ZoomStatus.initial,
    this.webUrl = '',
    this.errorMessage = '',
    this.progress = 0.0,
  });

  ZoomState copyWith({
    ZoomStatus? status,
    String? webUrl,
    String? errorMessage,
    double? progress,
  }) {
    return ZoomState(
      status: status ?? this.status,
      webUrl: webUrl ?? this.webUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object> get props => [status, webUrl, errorMessage, progress];
}
