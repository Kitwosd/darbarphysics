import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnrolledScreenHeaderWidget extends StatelessWidget {
  final int coursesNumber;
  const EnrolledScreenHeaderWidget({super.key, required this.coursesNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          TextWidget(word: 'My Courses', size: 24, weight: FontWeight.bold),
          TextWidget(
            word: '$coursesNumber Enrolled Courses',
            size: 16,
            weight: FontWeight.w800,
            textColor: appColors.primary,
          ),
        ],
      ),
    );
  }
}
