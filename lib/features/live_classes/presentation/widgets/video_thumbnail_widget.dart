import 'dart:ui';

import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoThumbnailWidget extends StatelessWidget {
  final VideoModel video;
  final int videoIndex;
  final bool canAccess;
  const VideoThumbnailWidget({
    super.key,
    required this.video,
    required this.videoIndex,
    required this.canAccess,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
