import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/routes/video_player_args.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedVideosListWidget extends StatelessWidget {
  final List<VideoModel> videos;
  const SavedVideosListWidget({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Slidable(
          key: ValueKey(video.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  context.read<VideosBookmarkBloc>().add(
                    RemoveVideoEvent(videoId: video.id),
                  );
                  OverlayToastWidget.show(
                    message: 'Course Removed from bookmarks',
                    bgColor: Colors.red.shade600,
                  );
                },
                backgroundColor: Colors.red.shade600,
                icon: Icons.delete,
                label: 'Remove',
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(12.r),
                ),
              ),
            ],
          ),

          child: GestureDetector(
            onTap: () => NavigationService.pushNamed(
              RouteName.videoPlayer,
              extra: VideoPlayerArgs(
                video: video,
                videoUrl: video.videoUrl,
                vidoeTitle: video.title,
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      videos[index].thumbnail,
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80.h,
                        width: 80.w,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          word: videos[index].title,
                          maxLines: 2,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: 5.h),
                        TextWidget(
                          word: 'Teacher',
                          textColor: Colors.grey,
                          size: 12,
                        ), // Mock
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14.sp, color: Colors.grey),
                            TextWidget(
                              word: " ${videos[index].course} Course",
                              textColor: Colors.grey,
                              size: 12,
                            ),
                            SizedBox(width: 10.w),
                            Icon(
                              Icons.watch_later_outlined,
                              size: 14.sp,
                              color: Colors.amber,
                            ),
                            TextWidget(
                              word: " ${videos[index].duration}",
                              textColor: Colors.grey,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
