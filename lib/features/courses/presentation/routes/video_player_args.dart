import 'package:durbar_physics/features/home/data/models/video_model.dart';

class VideoPlayerArgs {
  final VideoModel video;
  final String videoUrl;
  final String vidoeTitle;

  const VideoPlayerArgs({
    required this.video,
    required this.videoUrl,
    required this.vidoeTitle,
  });
}
