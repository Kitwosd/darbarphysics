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
                      if (liveClass.levelName != null)
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
                                  word: liveClass.levelName!,
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
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (liveClass.subjectName != null)
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
                                  word: liveClass.subjectName!,
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
                      Row(
                        children: [
                          TextWidget(
                            word: DateFormat(
                              'MMM d, h:mm a',
                            ).format(liveClass.startTime),
                            size: 11,
                            textColor: Theme.of(context).hintColor,
                          ),
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
