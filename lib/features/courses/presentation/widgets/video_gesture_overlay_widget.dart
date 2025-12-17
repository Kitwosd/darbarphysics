import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

class VideoGestureOverlayWidget extends StatefulWidget {
  final ValueNotifier<bool> isFullScreen;
  const VideoGestureOverlayWidget({super.key, required this.isFullScreen});

  @override
  State<VideoGestureOverlayWidget> createState() =>
      _VideoGestureOverlayWidgetState();
}

class _VideoGestureOverlayWidgetState extends State<VideoGestureOverlayWidget> {
  double _startY = 0;

  double _brightness = 0.5;
  double _volume = 0.5;
  late final VolumeController _volumeController;

  double? _indicatorValue; // null = hidden
  bool _showVolume = false;

  @override
  void initState() {
    super.initState();
    _volumeController = VolumeController.instance;
    _initValues();
  }

  Future<void> _initValues() async {
    _brightness = await ScreenBrightness().application;
    _volume = await _volumeController.getVolume();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isFullScreen,
      builder: (context, isFullScreen, _) {
        if (!isFullScreen) return const SizedBox();
        return Stack(
          children: [
            // Full overlay covering the player
            Positioned.fill(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left: Brightness (15% width)
                  Expanded(
                    flex: 15,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (details) {
                        _startY = details.globalPosition.dy;
                      },
                      onVerticalDragUpdate: (details) {
                        final delta = _startY - details.globalPosition.dy;
                        _handleBrightness(delta);
                        _indicatorValue = _brightness;
                        _showVolume = false;
                        _startY = details.globalPosition.dy;
                        setState(() {});
                      },
                      onVerticalDragEnd: (_) {
                        setState(() {
                          _indicatorValue = null;
                        });
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  // Middle: Pass-through (70% width)
                  const Expanded(flex: 70, child: SizedBox()),
                  // Right: Volume (15% width)
                  Expanded(
                    flex: 15,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (details) {
                        _startY = details.globalPosition.dy;
                      },
                      onVerticalDragUpdate: (details) {
                        final delta = _startY - details.globalPosition.dy;
                        _handleVolume(delta);
                        _indicatorValue = _volume;
                        _showVolume = true;
                        _startY = details.globalPosition.dy;
                        setState(() {});
                      },
                      onVerticalDragEnd: (_) {
                        setState(() {
                          _indicatorValue = null;
                        });
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),

            // Indicator UI
            if (_indicatorValue != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showVolume ? Icons.volume_up : Icons.brightness_6,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${(_indicatorValue! * 100).round()}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ); // Stack
      },
    );
  }

  void _handleBrightness(double delta) {
    double change = delta / 300;
    _brightness = (_brightness + change).clamp(0.0, 1.0);
    ScreenBrightness().setApplicationScreenBrightness(_brightness);
  }

  void _handleVolume(double delta) {
    double change = delta / 300;
    _volume = (_volume + change).clamp(0.0, 1.0);
    _volumeController.setVolume(_volume);
  }
}
