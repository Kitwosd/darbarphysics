import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'zoom_event.dart';
part 'zoom_state.dart';

class ZoomBloc extends Bloc<ZoomEvent, ZoomState> {
  // We can keep the original URL to retry
  String? _originalUrl;
  StreamSubscription? _connectivitySubscription;

  ZoomBloc() : super(const ZoomState()) {
    on<InitializeZoomEvent>(_onInitializeZoom);
    on<ZoomProgressUpdated>(_onProgressUpdated);
    on<ZoomWebResourceErrorEvent>(_onWebResourceError);
    on<ZoomConnectivityChangedEvent>(_onConnectivityChanged);
    on<ZoomRetryEvent>(_onRetry);
    on<ZoomMeetingEndedEvent>(
      _onMeetingEnded,
    ); // Fired when post-meeting page detected

    // Start listening to connectivity
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      add(ZoomConnectivityChangedEvent(isOnline));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }

  Future<void> _onInitializeZoom(
    InitializeZoomEvent event,
    Emitter<ZoomState> emit,
  ) async {
    emit(state.copyWith(status: ZoomStatus.loading));
    _originalUrl = event.originalUrl;

    // 1. Check Permissions
    final permissions = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    // ignore: unused_local_variable
    final allGranted = permissions.values.every((status) => status.isGranted);

    // Note: We proceed even if denied, but maybe show warning? For now just proceed.

    // 2. Check Internet (Initial)
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.every((r) => r == ConnectivityResult.none)) {
      emit(
        state.copyWith(
          status: ZoomStatus.connectivityError,
          errorMessage: 'No Internet Connection',
        ),
      );
      return;
    }

    // 3. Process URL
    final processedUrl = _convertToWebClientUrl(event.originalUrl);

    emit(
      state.copyWith(
        status: ZoomStatus.success,
        webUrl: processedUrl,
        progress: 0.1, // Start progress
      ),
    );
  }

  void _onProgressUpdated(ZoomProgressUpdated event, Emitter<ZoomState> emit) {
    // Only update progress if we are in success/loading state
    if (state.status == ZoomStatus.success ||
        state.status == ZoomStatus.loading) {
      emit(
        state.copyWith(
          progress: event.progress,
          // If progress is complete, we might want to say 'loaded' but 'success' is fine for "webview is active"
        ),
      );
    }
  }

  void _onWebResourceError(
    ZoomWebResourceErrorEvent event,
    Emitter<ZoomState> emit,
  ) {
    emit(
      state.copyWith(
        status: ZoomStatus.error,
        errorMessage: 'Zoom Error (${event.errorCode}): ${event.description}',
      ),
    );
  }

  void _onConnectivityChanged(
    ZoomConnectivityChangedEvent event,
    Emitter<ZoomState> emit,
  ) {
    if (!event.isOnline) {
      emit(
        state.copyWith(
          status: ZoomStatus.connectivityError,
          errorMessage: 'Internet connection lost',
        ),
      );
    } else {
      // If we were in an error state, we might auto-retry or just let user click retry
      if (state.status == ZoomStatus.connectivityError) {
        // Optionally confirm functionality or wait for user retry
        add(ZoomRetryEvent());
      }
    }
  }

  void _onRetry(ZoomRetryEvent event, Emitter<ZoomState> emit) {
    if (_originalUrl != null) {
      add(InitializeZoomEvent(_originalUrl!));
    }
  }

  /// Fired when the ShouldOverrideUrlLoading detects a Zoom post-meeting/promo URL.
  /// We simply emit a terminal state so the UI knows to auto-pop.
  void _onMeetingEnded(ZoomMeetingEndedEvent event, Emitter<ZoomState> emit) {
    emit(state.copyWith(status: ZoomStatus.meetingEnded));
  }

  /// Helper to convert standard Zoom URL to Web Client URL
  String _convertToWebClientUrl(String url) {
    if (url.contains('/wc/join/')) return url;

    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // Check for standard join link structure: /j/{meetingId}
      if (pathSegments.contains('j')) {
        final jIndex = pathSegments.indexOf('j');
        if (jIndex + 1 < pathSegments.length) {
          final meetingId = pathSegments[jIndex + 1];
          // Reconstruct
          // Keep query params (password)
          final newUri = uri.replace(path: '/wc/join/$meetingId');
          return newUri.toString();
        }
      }
    } catch (e) {
      // Fallback
    }
    return url;
  }
}
