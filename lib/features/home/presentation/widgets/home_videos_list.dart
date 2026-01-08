import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/courses/presentation/screens/video_player_screen.dart';
import 'package:durbar_physics/features/home/presentation/bloc/videos/videos_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeVideosList extends StatelessWidget {
  const HomeVideosList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosBloc, VideosState>(
      builder: (BuildContext context, VideosState state) {
        if (state.videos.isEmpty) {
          return const SizedBox.shrink();
        } else if (state.status == ApiDataStatus.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.status == ApiDataStatus.success) {
          return SizedBox(
            height: 190.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: state.videos.length,
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                final video = state.videos[index];
                return InkWell(
                  child: Container(
                    width: 250.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).shadowColor.withValues(alpha: .05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.r),
                              ),
                              child:
                                  // TODO: ask for the thumbnail for the video along  with actual video
                                  // Image.network(
                                  //   video.thumbnail.isEmpty
                                  //       ? "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1473&q=80"
                                  //       : video.thumbnail,
                                  Image.network(
                                    "https://images.unsplash.com/photo-1497633762265-9d179a990aa6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1473&q=80",
                                    height: 120.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, _) => Container(
                                      height: 120.h,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  word: video.title,
                                  size: 14,
                                  weight: FontWeight.bold,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        video: video,
                        videoUrl: video.videoUrl,
                        title: video.title,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state.status == ApiDataStatus.error) {
          return SizedBox.shrink();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
