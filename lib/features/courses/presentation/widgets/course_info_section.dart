import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/presentation/screens/document_list_screen.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/grade_badge.dart';
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
            10.verticalSpace,
            GradeBadge(grade: course.levelName ?? 'Unknown'),
            10.verticalSpace,
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
                        Icon(Icons.menu_book, size: 16.sp, color: Colors.grey),
                        5.horizontalSpace,
                        TextWidget(
                          word: course.subjectName ?? 'Unknown',
                          textColor: Colors.grey,
                          size: 12,
                        ),
                        12.horizontalSpace,
                        Container(
                          width: 1.w,
                          height: 14.h,
                          color: Colors.grey.shade400,
                        ),
                        12.horizontalSpace,
                        Icon(
                          Icons.video_library,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        5.horizontalSpace,
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
                        2.horizontalSpace,
                        Icon(Icons.star, size: 16.sp, color: Colors.amber),
                        SizedBox(width: 5.w),
                        TextWidget(
                          word: "${course.rating} (${course.reviewCount})",
                          weight: FontWeight.bold,
                          size: 12,
                        ),
                        12.horizontalSpace,
                        Container(
                          width: 1.w,
                          height: 14.h,
                          color: Colors.grey.shade400,
                        ),
                        12.horizontalSpace,
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
                if (course.isUserLocked == false)
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
                              builder: (context) =>
                                  DocumentListScreen(courseId: course.id),
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
