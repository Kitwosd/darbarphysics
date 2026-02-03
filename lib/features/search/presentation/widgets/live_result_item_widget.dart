import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LiveResultItemWidget extends StatelessWidget {
  final LiveClassModel liveClass;

  const LiveResultItemWidget({super.key, required this.liveClass});

  String _formatTeacherName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.pushNamed(
          RouteName.liveclassDetail,
          extra: liveClass.id,
        );
        // if (liveClass.isUserLocked) {
        //   NavigationService.pushNamed(
        //     RouteName.liveclassDetail,
        //     extra: liveClass.id,
        //   );
        //   logger.d('Is locked ?: courseID: ${liveClass.course}');
        //   return;
        // }
        // if (liveClass.isLive) {
        //   NavigationService.pushNamed(
        //     RouteName.zoomWebView,
        //     extra: {'url': liveClass.meetingUrl},
        //   );
        // } else {
        //   NavigationService.pushNamed(
        //     RouteName.liveclassDetail,
        //     extra: liveClass.id,
        //   );
        // }
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
                    word: liveClass.title,
                    size: 14,
                    weight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14.sp,
                        color: Theme.of(context).hintColor,
                      ),
                      SizedBox(width: 4.w),
                      TextWidget(
                        word: _formatTeacherName(liveClass.teacherName),
                        size: 12,
                        textColor: Theme.of(context).hintColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      TextWidget(
                        word: DateFormat(
                          'MMM d, h:mm a',
                        ).format(liveClass.startTime),
                        size: 11,
                        textColor: Theme.of(context).hintColor,
                      ),

                      if (liveClass.isUserLocked) ...[
                        Spacer(),
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
                  if (liveClass.isLive) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          TextWidget(
                            word: 'LIVE NOW',
                            size: 10,
                            textColor: Colors.red,
                            weight: FontWeight.bold,
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade400, Colors.pink.shade400],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: liveClass.thumbnail.isNotEmpty
                ? Image.network(
                    liveClass.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
        ),
        if (liveClass.isLive)
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  TextWidget(
                    word: 'LIVE',
                    size: 9,
                    textColor: Colors.white,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.videocam, size: 32.sp, color: Colors.white),
    );
  }
}
