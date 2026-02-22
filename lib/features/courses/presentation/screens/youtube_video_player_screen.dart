import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: TextWidget(
              word: widget.video.title,
              textColor: Colors.white,
              weight: FontWeight.w800,
            ),
            leading: BackButton(color: Colors.white),
            actions: [
              Builder(
                builder: (context) {
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape) {
                    return const SizedBox();
                  }
                  return BlocBuilder<VideosBookmarkBloc, VideosBookmarkState>(
                    builder: (context, state) {
                      final isBookmarked = state.videoIds.contains(
                        widget.video.id,
                      );

                      return IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (isBookmarked) {
                            context.read<VideosBookmarkBloc>().add(
                              RemoveVideoEvent(videoId: widget.video.id),
                            );
                            OverlayToastWidget.show(
                              bgColor: Colors.red.shade400,
                              message: "Removed from bookmarks",
                            );
                          } else {
                            context.read<VideosBookmarkBloc>().add(
                              AddVideoEvent(video: widget.video),
                            );
                            OverlayToastWidget.show(
                              message: "Added to bookmarks",
                              bgColor: Colors.green.shade400,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
            textColor: Colors.white,
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
