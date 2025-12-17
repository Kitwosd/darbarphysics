import 'package:durbar_physics/features/courses/presentation/widgets/video_player_screen_widget.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title, style: TextStyle(color: Colors.white)),
        leading: BackButton(color: Colors.white),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: VideoPlayerScreenWidget(
                    title: title,
                    videoUrl: videoUrl,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
