import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _videoId = YoutubePlayer.convertUrlToId(widget.video.videoUrl) ?? '';

    if (_videoId.isEmpty) {
      _hasError = true;
      return;
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
    if (!_hasError) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return ErrorScreen(
        errorTitle: 'Video is unavailable',
        errorMessage: 'The video URL is invalid or unsupported',
        homeButtonText: 'Go back',
        onGoHome: () => NavigationService.pop(),
      );
    }
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
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextWidget(
            word: widget.video.title,
            size: 18,
            maxLines: 3,
            weight: FontWeight.bold,
            textColor: Colors.white,
          ),
          8.verticalSpace,
          TextWidget(
            word: 'Duration: ${widget.video.duration}',
            textColor: Colors.grey,
          ),
          8.verticalSpace,
          if (widget.video.levelName != null)
            Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  size: 15.sp,
                  color: const Color(0xFF6366F1),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: TextWidget(
                    word: widget.video.levelName!,
                    size: 14,
                    weight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textColor: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          8.verticalSpace,

          if (widget.video.subjectName != null)
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 15.sp,
                  color: const Color(0xFF10B981),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: TextWidget(
                    word: widget.video.subjectName!,
                    size: 14,
                    weight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textColor: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
