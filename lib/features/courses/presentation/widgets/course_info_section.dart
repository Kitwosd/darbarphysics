import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/presentation/screens/document_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseInfoSection extends StatelessWidget {
  final CourseDetailModel course;

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
            TextWidget(
              word: course.title,
              size: 22,
              weight: FontWeight.bold,
              maxLines: 2,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5.w),
                        TextWidget(
                          word: course.totalDuration,
                          textColor: Colors.grey,
                          size: 12,
                        ),
                        SizedBox(width: 15.w),
                        Icon(
                          Icons.video_library,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
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
                          word: (double.tryParse(course.cost) ?? 0) == 0
                              ? 'Free Course'
                              : "${course.studentCount} Students",
                          textColor: Colors.grey,
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: appColors.primary.withValues(alpha: 0.3),
                        blurRadius: 0.r,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      // splashColor: Colors.red,
                      // highlightColor: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DocumentsListScreen(),
                          ),
                        );
                      },
                      child: Ink(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 135, 137, 237),
                              appColors.primary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                            6.horizontalSpace,
                            TextWidget(
                              word: 'Document',
                              textColor: customColors.whiteBlack,
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
