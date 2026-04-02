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
      margin: EdgeInsets.only(bottom: 12.h), // Added margin for list spacing
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align to top for better text wrapping
        children: [
          LiveClassThumbnailWidget(liveClass: liveClass),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Title ---
                TextWidget(
                  word: liveClass.title,
                  overflow: TextOverflow.visible,
                  size: 15,
                  weight: FontWeight.bold,
                  textColor: Theme.of(context).primaryColorDark,
                ),
                4.verticalSpace,

                // --- Instructor ---
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14.sp, color: Colors.grey),
                    4.horizontalSpace,
                    TextWidget(
                      word: liveClass.teacherName,
                      size: 13,
                      textColor: Theme.of(context).primaryColorLight,
                    ),
                  ],
                ),
                6.verticalSpace,

                // --- Time ---
                TextWidget(
                  word: DateFormat('MMM d, h:mm a').format(liveClass.startTime),
                  size: 11,
                  textColor: Colors.grey.shade600,
                  weight: FontWeight.w500,
                ),
              ],
            ),
          ),

          // --- Status & Lock Section ---
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              5.verticalSpace,
              if (liveClass.levelName != null) ...[
                _buildSmallBadge(
                  context,
                  label: liveClass.levelName ?? '', // e.g., "Grade 12"
                  bgColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  textColor: Theme.of(context).primaryColor,
                ),
                8.verticalSpace,
              ],
              if (liveClass.subjectName != null) ...[
                _buildSmallBadge(
                  context,
                  label: liveClass.subjectName ?? '', // e.g., "Physics"
                  bgColor: Colors.grey.shade600,
                  textColor: Colors.yellow.shade500,
                ),
                8.verticalSpace,
              ],

              LockedIconWidget(isUserLocked: liveClass.isUserLocked),
            ],
          ),
        ],
      ),
    );
  }

  // Helper for Grade/Subject badges
  Widget _buildSmallBadge(
    BuildContext context, {
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  // Helper for the "LIVE" tag
  // ignore: unused_element
  Widget _buildLiveIndicator() {
    return Container(
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
    );
  }
}
