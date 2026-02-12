import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final VideoModel video;
  const YoutubeVideoPlayerScreen({super.key, required this.video});

  @override
  State<YoutubeVideoPlayerScreen> createState() =>
      _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  late YoutubePlayerController _controller;
  late String _videoId;

  @override
  void initState() {
    super.initState();

    _videoId = YoutubePlayer.convertUrlToId(widget.video.videoUrl) ?? '';

    if (_videoId.isEmpty) {
      throw Exception('Invalid Youtube URL');
    }

    _controller = YoutubePlayerController(
      initialVideoId: _videoId,

      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: false,
        hideControls: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,

        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: TextWidget(word: widget.video.title)),
          body: Column(children: [player, _buildVideoInfo()]),
        );
      },
    );
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            word: widget.video.title,
            size: 18,
            weight: FontWeight.bold,
          ),
          8.verticalSpace,
          TextWidget(
            word: 'Duration: ${widget.video.duration}',
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
