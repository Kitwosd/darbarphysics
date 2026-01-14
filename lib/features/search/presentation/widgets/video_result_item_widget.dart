import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/routes/video_player_args.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoResultItemWidget extends StatelessWidget {
  final VideoModel video;

  const VideoResultItemWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.pushNamed(
          RouteName.videoPlayer,
          extra: VideoPlayerArgs(
            video: video,
            videoUrl: video.videoUrl,
            videoTitle: video.title,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildThumbnail(context),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    word: video.title,
                    size: 14,
                    weight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 14.sp,
                        color: Theme.of(context).hintColor,
                      ),
                      SizedBox(width: 4.w),
                      TextWidget(
                        word: video.duration.isNotEmpty
                            ? video.duration
                            : 'Video',
                        size: 12,
                        textColor: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                  if (video.isLocked) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 10.sp,
                            color: Colors.orange.shade700,
                          ),
                          SizedBox(width: 4.w),
                          TextWidget(
                            word: 'Locked',
                            size: 10,
                            textColor: Colors.orange.shade700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 75.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: video.thumbnail.isNotEmpty
                ? Image.network(
                    video.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                  )
                : _buildPlaceholder(context),
          ),
        ),
        if (video.duration.isNotEmpty)
          Positioned(
            bottom: 6.h,
            right: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: TextWidget(
                word: video.duration,
                size: 10,
                textColor: Colors.white,
                weight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.play_circle_outline,
        size: 32.sp,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
