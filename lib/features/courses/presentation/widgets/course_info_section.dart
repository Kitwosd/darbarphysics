import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/features/courses/data/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseInfoSection extends StatelessWidget {
  final CourseModel course;

  const CourseInfoSection({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            TextWidget(word: course.title, size: 22, weight: FontWeight.bold),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.access_time_filled, size: 16.sp, color: Colors.grey),
                SizedBox(width: 5.w),
                TextWidget(
                  word: course.totalDuration,
                  textColor: Colors.grey,
                  size: 12,
                ),
                SizedBox(width: 15.w),
                Icon(Icons.video_library, size: 16.sp, color: Colors.grey),
                SizedBox(width: 5.w),
                TextWidget(
                  word: "${course.lessonCount} Lessons",
                  textColor: Colors.grey,
                  size: 12,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.star, size: 16.sp, color: Colors.amber),
                SizedBox(width: 5.w),
                TextWidget(
                  word: "${course.rating} (${course.reviewCount})",
                  weight: FontWeight.bold,
                  size: 12,
                ),
                SizedBox(width: 15.w),
                Icon(Icons.person, size: 16.sp, color: Colors.grey),
                SizedBox(width: 5.w),
                TextWidget(
                  word: "${course.studentCount} Students",
                  textColor: Colors.grey,
                  size: 12,
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
