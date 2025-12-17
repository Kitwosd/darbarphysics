import 'package:better_player_plus/better_player_plus.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/video_gesture_overlay_widget.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreenWidget extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreenWidget({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreenWidget> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreenWidget> {
  late BetterPlayerController _betterPlayerController;
  final ValueNotifier<bool> isFullScreen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoPlay: true,
          looping: false,
          fullScreenByDefault: false,
          allowedScreenSleep: false,

          // Use the overlay property to display the gesture widget
          overlay: VideoGestureOverlayWidget(isFullScreen: isFullScreen),

          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSkips: true,
            enableFullscreen: true,
            enablePip: true,
            enablePlayPause: true,
            enableMute: true,
            enableProgressBar: true,

            controlBarColor: Colors.black54,
            loadingColor: Colors.blue,
            progressBarPlayedColor: Colors.blue,
            progressBarHandleColor: Colors.blue,
            enablePlaybackSpeed: true,
            showControls: true,
          ),
        );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoUrl,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.title,
        author: "Durbar Physics",
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    // Listen to fullscreen events to update the notifier
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.openFullscreen) {
        isFullScreen.value = true;
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.hideFullscreen) {
        isFullScreen.value = false;
      }
    });

    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    isFullScreen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _betterPlayerController);
  }
}
