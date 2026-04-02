import 'dart:ui';

import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeVideoCardWidget extends StatelessWidget {
  final int videoIndex;
  final VideoModel video;
  final VoidCallback onTap;
  const HomeVideoCardWidget({
    super.key,
    required this.video,
    required this.onTap,
    required this.videoIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool canAccess = !(video.isLocked && video.isUserLocked);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          padding: EdgeInsets.all(8.w),

          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _thumbnailWidget(video, videoIndex, context, isDark, canAccess),
              12.horizontalSpace,
              Expanded(child: _titleWidget(video, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lockedIconWidget(
    VideoModel video,
    BuildContext context,
    bool canAccess,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: !canAccess ? Colors.yellow[100] : Colors.green[100],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TextWidget(
            word: !canAccess ? 'LOCKED' : 'UNLOCKED',
            weight: FontWeight.bold,
            size: 10,
            textColor: !canAccess ? Colors.yellow[900] : Colors.green[900],
          ),
        ),

        // Icon(
        //   Icons.chevron_right_rounded,
        //   size: 24.sp,
        //   color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.4),
        // ),
      ],
    );
  }

  Widget _titleWidget(VideoModel video, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Title
        TextWidget(
          word: video.title,
          size: 15,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          weight: FontWeight.w600,
        ),
        SizedBox(height: 6.h),

        // Grade Row - Simple split with fixed space allocation
        Row(
          children: [
            // Left side - Grade info with fixed width
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

            // Right side - Locked status (fixed size)
            SizedBox(width: 8.w),
            _lockedIconWidget(
              video,
              context,
              !(video.isLocked && video.isUserLocked),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Subject Row - Same pattern
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 4.w),
                TextWidget(
                  word: video.duration,
                  size: 12,
                  textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                5.horizontalSpace,
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _thumbnailWidget(
    VideoModel video,
    int videoIndex,
    BuildContext context,
    bool isDark,
    bool canAccess,
  ) {
    return Container(
      width: 120.w,
      height: 80.h,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey[800]!, Colors.grey[900]!]
              : [Colors.red[50]!, Colors.red[100]!],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(8.r),
        child: Stack(
          children: [
            if (video.thumbnail != null && video.thumbnail!.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  video.thumbnail!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        size: 40.sp,
                        color: Colors.red[600],
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Icon(
                  Icons.play_circle_filled,
                  size: 28,
                  color: Colors.red[600],
                ),
              ),

            if (!canAccess)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.lock_rounded,
                          size: 28.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Play button overlay for unlocked videos
            if (canAccess)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 4,
              left: 4,

              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,

                    colors: [Colors.black, Colors.black.withValues(alpha: 0.3)],
                  ),
                ),

                child: TextWidget(
                  size: 12,
                  word: '#${videoIndex + 1}',
                  textColor: Colors.white70,
                  weight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
