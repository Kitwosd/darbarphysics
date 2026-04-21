import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ScheduleInfoCardWidget extends StatelessWidget {
  final LiveClassDetailModel liveClass;
  const ScheduleInfoCardWidget({super.key, required this.liveClass});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20.sp, color: appColors.primary),
              8.horizontalSpace,
              TextWidget(
                word: 'Class Schedule',
                size: 16,
                weight: FontWeight.bold,
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildTimeInfo(
                  context,
                  'Start Time',
                  DateFormat('MMM d, yyyy').format(liveClass.startTime),
                  DateFormat('h: mm a').format(liveClass.startTime),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _buildTimeInfo(
                  context,
                  'End Time',
                  DateFormat('MMM d, yyyy').format(liveClass.endTime),
                  DateFormat('h:mm a').format(liveClass.endTime),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          _buildDurationInfo(context),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
    BuildContext context,
    String label,
    String date,
    String time,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: appColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            word: label,
            size: 11,
            textColor: Theme.of(context).hintColor,
          ),
          6.verticalSpace,
          TextWidget(word: date, size: 13, weight: FontWeight.w600),
          2.verticalSpace,
          TextWidget(
            word: time,
            size: 12,
            textColor: appColors.primary,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade200, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 18.sp, color: Colors.blue.shade700),
          SizedBox(width: 8.w),
          TextWidget(
            word: 'Duration: ',
            size: 13,
            textColor: Colors.blue.shade700,
          ),
          TextWidget(
            word: liveClass.duration,
            size: 13,
            weight: FontWeight.bold,
            textColor: Colors.blue.shade900,
          ),
        ],
      ),
    );
  }
}
