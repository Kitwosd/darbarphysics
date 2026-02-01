import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/live_class_thumbnail_widget.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/locked_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LiveClassCardWidget extends StatelessWidget {
  final LiveClassModel liveClass;
  final int index;
  const LiveClassCardWidget({
    super.key,
    required this.liveClass,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LiveClassThumbnailWidget(liveClass: liveClass),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  word: liveClass.title,
                  overflow: TextOverflow.visible,
                  size: 16,
                  weight: FontWeight.bold,
                  textColor: Theme.of(context).primaryColorDark,
                ),
                SizedBox(height: 4.h),
                TextWidget(
                  word: liveClass.teacherName,
                  size: 14,
                  textColor: Theme.of(context).primaryColorLight,
                ),
                SizedBox(height: 4.h),
                TextWidget(
                  word: DateFormat('MMM d, h:mm a').format(liveClass.startTime),
                  size: 12,
                  textColor: Colors.grey,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (liveClass.status == 'live')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: const TextWidget(
                    word: "LIVE",
                    size: 10,
                    textColor: Colors.white,
                    weight: FontWeight.bold,
                  ),
                ),
              20.verticalSpace,
              LockedIconWidget(isUserLocked: liveClass.isUserLocked),
            ],
          ),
        ],
      ),
    );
  }
}
