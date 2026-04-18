import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/routes/video_player_args.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/saved_video_thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedVideosListWidget extends StatefulWidget {
  final List<VideoModel> videos;
  const SavedVideosListWidget({super.key, required this.videos});

  @override
  State<SavedVideosListWidget> createState() => _SavedVideosListWidgetState();
}

class _SavedVideosListWidgetState extends State<SavedVideosListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollBarWrapperWidget(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(20.w),
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          bool canAccess = !(video.isUserLocked && video.isLocked);
          return Slidable(
            key: ValueKey(video.id),
            startActionPane: ActionPane(
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
                RouteName.youtubeVideoPlayerScreen,
                extra: VideoPlayerArgs(
                  video: video,
                  videoUrl: video.videoUrl,
                  videoTitle: video.title,
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 15.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                padding: EdgeInsets.all(12.w),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Thumbnail
                    SizedBox(
                      height: 80.h,
                      width: 80.w,
                      child: SavedVideoThumbnailWidget(
                        video: video,
                        videoIndex: index,
                        canAccess: canAccess,
                      ),
                    ),

                    SizedBox(width: 15.w),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            word: video.title,
                            maxLines: 2,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 5.h),

                          if (video.subjectName != null)
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
                                    word: video.subjectName!,
                                    size: 12,
                                    weight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),

                          SizedBox(height: 5.h),

                          Row(
                            children: [
                              if (video.levelName != null)
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.school_rounded,
                                        size: 15.sp,
                                        color: const Color(0xFF6366F1),
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: TextWidget(
                                          word: video.levelName!,
                                          size: 12,
                                          weight: FontWeight.w600,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textColor: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(width: 8.w),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14.sp,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 4.w),
                                  TextWidget(
                                    word: video.duration,
                                    size: 12,
                                    textColor: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  5.horizontalSpace,
                                ],
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
      ),
    );
  }
}
