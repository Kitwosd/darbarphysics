import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player_plus/src/controls/better_player_material_controls.dart';
import 'package:dubar_physics/features/courses/presentation/widgets/video_gesture_overlay_widget.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreenWidget extends StatefulWidget {
  final String videoUrl;
  final String title;
  final ValueNotifier<bool> isFullScreen;

  const VideoPlayerScreenWidget({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.isFullScreen,
  });

  @override
  State<VideoPlayerScreenWidget> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreenWidget> {
  late BetterPlayerController _betterPlayerController;

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
            customControlsBuilder: (controller, onPlayerVisibilityChanged) {
              return Stack(
                children: [
                  BetterPlayerMaterialControls(
                    onControlsVisibilityChanged: onPlayerVisibilityChanged,
                    controlsConfiguration: controller
                        .betterPlayerConfiguration
                        .controlsConfiguration,
                  ),
                  VideoGestureOverlayWidget(isFullScreen: widget.isFullScreen),
                ],
              );
            },
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

    //fullScreen detection
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.openFullscreen) {
        widget.isFullScreen.value = true;
      }
      if (event.betterPlayerEventType == BetterPlayerEventType.hideFullscreen) {
        widget.isFullScreen.value = false;
      }
    });

    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BetterPlayer(controller: _betterPlayerController);
  }
}
