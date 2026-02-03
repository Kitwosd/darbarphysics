import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/video_player_screen_widget.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPlayerScreen extends StatelessWidget {
  final VideoModel video;
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title, style: TextStyle(color: Colors.white)),
        leading: BackButton(color: Colors.white),
        actions: [
          Builder(
            builder: (context) {
              if (MediaQuery.of(context).orientation == Orientation.landscape) {
                return const SizedBox();
              }
              return BlocBuilder<VideosBookmarkBloc, VideosBookmarkState>(
                builder: (context, state) {
                  // Create a temporary ID using hashCode since we don't have ID passed here
                  // Ideally, we should pass the ID. For now, we assume videoUrl is unique enough or use a mock ID
                  // But waiting, the VideoBookmarkBloc uses ID for removal.
                  // Since I don't have the ID passed in constructor, I cannot reliably check isBookmarked.
                  // I will trust the user to fix the ID passing later, but implement the UI logic now.
                  // Actually, I can search by title or URL if ID is missing, but standard is ID.
                  // For now I will assume the passed arguments are insufficient and I will use hashCode as fallback ID
                  // or better, ask user to update navigation to pass video object.
                  // Proceeding with UI implementation assuming standard behavior.

                  // Actually, looking at the previous file content, only videoUrl and title are passed.
                  // This is a limitation. I'll implement the UI logic and use a generated ID (hashCode)
                  // for now so it works visually, but the user should pass the full video object later.

                  final isBookmarked = state.videoIds.contains(video.id);

                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (isBookmarked) {
                        context.read<VideosBookmarkBloc>().add(
                          RemoveVideoEvent(videoId: video.id),
                        );
                        OverlayToastWidget.show(
                          bgColor: Colors.red.shade400,
                          message: "Removed from bookmarks",
                        );
                      } else {
                        context.read<VideosBookmarkBloc>().add(
                          AddVideoEvent(video: video),
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
