import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/features/courses/data/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseOverviewTab extends StatelessWidget {
  final CourseModel course;

  const CourseOverviewTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
