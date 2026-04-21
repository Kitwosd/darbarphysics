part of 'zoom_bloc.dart';

abstract class ZoomEvent extends Equatable {
  const ZoomEvent();

  @override
  List<Object> get props => [];
}

class InitializeZoomEvent extends ZoomEvent {
  final String originalUrl;
  const InitializeZoomEvent(this.originalUrl);

  @override
  List<Object> get props => [originalUrl];
}

class ZoomProgressUpdated extends ZoomEvent {
  final double progress;
  const ZoomProgressUpdated(this.progress);

  @override
  List<Object> get props => [progress];
}

class ZoomWebResourceErrorEvent extends ZoomEvent {
  final String errorCode;
  final String description;

  const ZoomWebResourceErrorEvent(this.errorCode, this.description);

  @override
  List<Object> get props => [errorCode, description];
}

class ZoomConnectivityChangedEvent extends ZoomEvent {
  final bool isOnline;
  const ZoomConnectivityChangedEvent(this.isOnline);

  @override
  List<Object> get props => [isOnline];
}

class ZoomRetryEvent extends ZoomEvent {}

/// Fired when the WebView navigates to a Zoom post-meeting/promo page,
/// meaning the user has left the call.
class ZoomMeetingEndedEvent extends ZoomEvent {}
