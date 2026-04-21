import 'package:durbar_physics/common/widgets/enrollment_dialog_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoResultItemWidget extends StatelessWidget {
  final VideoModel video;

  const VideoResultItemWidget({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    bool canAccess = !(video.isLocked && video.isUserLocked);
    return InkWell(
      onTap: () {
        if (!canAccess) {
          if (video.course != null) {
            EnrollmentDialogWidget.show(
              context,
              forVideo: true,
              onGoToCourse: () => {
                NavigationService.pushNamedReplacement(
                  RouteName.detailScreen,

                  extra: video.course, //extra: video.courseId,
                ),
              },
            );
          }

          return;
        }

        NavigationService.pushNamed(
          RouteName.youtubeVideoPlayerScreen,
          extra: video,
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
                      // Icon(
                      //   Icons.play_circle_outline,
                      //   size: 14.sp,
                      //   color: Theme.of(context).hintColor,
                      // ),
                      // SizedBox(width: 4.w),
                      // TextWidget(
                      //   word: video.duration.isNotEmpty
                      //       ? video.duration
                      //       : 'Video',
                      //   size: 12,
                      //   textColor: Theme.of(context).hintColor,
                      // ),
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
                                  textColor: Theme.of(context).hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                      if (video.isUserLocked) ...[
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: !canAccess
                                ? Colors.orange[50]
                                : Colors.green[100],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                !canAccess
                                    ? Icons.face_unlock_outlined
                                    : Icons.lock,
                                size: 10.sp,
                                color: !canAccess
                                    ? Colors.orange[900]
                                    : Colors.green[900],
                              ),
                              SizedBox(width: 4.w),
                              TextWidget(
                                word: !canAccess ? 'LOCKED' : 'UNLOCKED',
                                size: 10,
                                textColor: !canAccess
                                    ? Colors.orange[900]
                                    : Colors.green[900],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  5.verticalSpace,
                  Row(
                    children: [
                      // Left side - Subject info
                      if (video.subjectName != null)
                        Expanded(
                          child: Row(
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
                        ),

                      // Right side - Duration (fixed size)
                      SizedBox(width: 8.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
            child: video.thumbnail!.isNotEmpty && video.thumbnail != null
                ? Image.network(
                    video.thumbnail!,
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
