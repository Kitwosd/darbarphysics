import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassHeroCardWidget extends StatelessWidget {
  final LiveClassDetailModel liveClass;
  const ClassHeroCardWidget({super.key, required this.liveClass});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appColors.primary, appColors.primary.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: appColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBadge(context),
          16.verticalSpace,
          TextWidget(
            word: liveClass.title,
            size: 20,
            weight: FontWeight.bold,
            textColor: Colors.white,
            maxLines: 3,
          ),
          16.verticalSpace,
          _buildTeacherInfo(context),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor;
    String statusText;
    IconData statusIcon;

    switch (liveClass.status) {
      case 'live':
        badgeColor = Colors.red;
        statusText = 'LIVE NOW';
        statusIcon = Icons.circle;
        break;

      case 'upcoming':
        badgeColor = Colors.orange;
        statusText = 'UPCOMING';
        statusIcon = Icons.schedule;
      case 'ended':
        badgeColor = Colors.grey;
        statusText = 'ENDED';
        statusIcon = Icons.check_circle;
      default:
        badgeColor = Colors.orange;
        statusText = 'UPCOMING';
        statusIcon = Icons.check_circle;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14.sp, color: badgeColor),
          6.horizontalSpace,
          TextWidget(
            word: statusText,
            size: 12,
            weight: FontWeight.bold,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: TextWidget(
              word: liveClass.teacher.length >= 2
                  ? liveClass.teacher.substring(0, 2).toUpperCase()
                  : liveClass.teacher.toUpperCase(),
              weight: FontWeight.bold,
              textColor: appColors.primary,
            ),
          ),
        ),
        12.horizontalSpace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              word: _formatTeacherName(liveClass.teacher),
              size: 14,
              weight: FontWeight.w400,
              textColor: Colors.white,
            ),
            2.verticalSpace,
            TextWidget(
              word: 'Instructor',
              size: 12,
              textColor: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTeacherName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
