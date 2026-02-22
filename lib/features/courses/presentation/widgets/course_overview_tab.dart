import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseOverviewTab extends StatelessWidget {
  final CourseDetailModel course;

  const CourseOverviewTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !course.isUserLocked
              ? _userAlreadyEnrolledCard(context)
              : SizedBox.shrink(),
          20.verticalSpace,
          const TextWidget(
            word: "Introduction",
            size: 18,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 10.h),
          TextWidget(
            word: course.description,
            textColor: Theme.of(context).textTheme.bodyMedium?.color,
            maxLines: 10,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                context,
                course.rating.toString(),
                "Reviews",
                Icons.star,
                Colors.amber,
              ),
              SizedBox(width: 10.w),
              _buildStatCard(
                context,
                course.studentCount.toString(),
                "Students",
                Icons.people,
                Colors.blue,
              ),
            ],
          ),

          10.verticalSpace,
        ],
      ),
    );
  }

  Widget _userAlreadyEnrolledCard(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withValues(alpha: 0.3), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  word: "You're enrolled 🎉",
                  weight: FontWeight.bold,
                  size: 16,
                ),
                SizedBox(height: 6.h),
                TextWidget(
                  word: "You have full access to all lessons and live classes.",
                  size: 13,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(word: value, weight: FontWeight.bold, size: 16),
                TextWidget(word: label, textColor: Colors.grey, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
