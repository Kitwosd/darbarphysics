import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/data/model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerSlideWidget extends StatelessWidget {
  final BannerModel banner;
  const BannerSlideWidget({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        NavigationService.pushNamed(
          RouteName.detailScreen,
          extra: banner.courseId,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Banner Image ──
              Image.network(
                banner.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image_rounded,
                        size: 40.sp,
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Image unavailable',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                        color: colorScheme.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),

              // ── Gradient Overlay — always dark so text is always readable ──
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.35, 1.0],
                    colors: [
                      Colors.transparent,
                      Color(0x26000000), // ~15% black
                      Color(0xCC000000), // ~80% black
                    ],
                  ),
                ),
              ),

              // ── Content ──
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 14.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 6.h),

                    // Title
                    Text(
                      banner.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors
                            .white, // always white — sits on dark gradient
                        height: 1.3,
                        shadows: const [
                          Shadow(
                            color: Color(0x66000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // Tap hint row
                    Row(
                      children: [
                        Text(
                          'Tap to explore',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.75),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 12.sp,
                          color: Colors.white.withValues(alpha: 0.75),
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
  }
}
