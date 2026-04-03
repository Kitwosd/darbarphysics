import 'package:durbar_physics/common/widgets/button_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnrolledCourseCardWidget extends StatelessWidget {
  final int courseIndex;
  final CourseModel course;
  final VoidCallback onTap;
  const EnrolledCourseCardWidget({
    super.key,
    required this.courseIndex,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: customColors.blackWhite.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
        // border: Border.all(
        //   color: Theme.of(context).cardColor.withValues(alpha: 0.1),
        //   width: 1,
        // ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image
          courseImageHeader(
            thumbnail: course.image,
            index: courseIndex,
            title: course.title,
            cost: course.cost,
            rating: course.rating,
            context: context,
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: TextWidget(
              word: course.title,
              size: 18,
              weight: FontWeight.w800,
            ),
          ),
          10.verticalSpace,

          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                if (course.levelName != null)
                  TextWidget(
                    word: course.levelName ?? '',
                    size: 13,
                    weight: FontWeight.w500,
                    textColor: customColors.blackWhite.withValues(alpha: 0.6),
                  ),
                6.horizontalSpace,
                if (course.subjectName != null)
                  Container(
                    height: 6.h,
                    width: 6.h,
                    color: customColors.blackWhite.withValues(alpha: 0.6),
                  ),

                6.horizontalSpace,
                if (course.subjectName != null)
                  TextWidget(
                    word: course.subjectName ?? '',
                    size: 13,
                    weight: FontWeight.w500,
                    textColor: customColors.blackWhite.withValues(alpha: 0.6),
                  ),
              ],
            ),
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: courseStatsGrid(
              studentCount: course.studentCount,
              lessonCount: course.lessonCount,
              liveCount: course.liveClassCount,
              context: context,
            ),
          ),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: ButtonWidget(
              width: 400.w,
              textWidget: TextWidget(
                word: 'Continue Course',
                weight: FontWeight.w600,
                textColor: customColors.whiteBlack,
              ),
              onPressed: onTap,
              bgColor: appColors.primary,
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget courseStatsGrid({
    required int lessonCount,
    required int studentCount,
    required int liveCount,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Expanded(
          child: statsBox(
            icon: Icons.people_outline,
            value: studentCount.toString(),
            label: 'Students',
            context: context,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: statsBox(
            icon: Icons.menu_book_outlined,
            value: lessonCount.toString(),
            label: 'Lessons',
            context: context,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: statsBox(
            icon: Icons.videocam_outlined,
            value: liveCount.toString(),
            label: 'Live',
            context: context,
          ),
        ),
      ],
    );
  }

  Widget statsBox({
    required IconData icon,
    required String value,
    required String label,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Theme.of(context).primaryColor,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: appColors.primary, size: 24.sp),
          TextWidget(
            word: value,
            textColor: customColors.blackWhite.withValues(alpha: .55),
            size: 14,
            weight: FontWeight.w500,
          ),
          TextWidget(
            word: label,
            textColor: customColors.blackWhite.withValues(alpha: .40),
            size: 14,
            weight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget courseImageHeader({
    required int index,
    required String title,
    required String cost,
    required double rating,
    required String? thumbnail,
    required BuildContext context,
  }) {
    // ✅ Fix thumbnail path
    String imagePath = thumbnail ?? '';

    if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
      imagePath = '${dotenv.env['BASE_THUMBNAIL_URL']}$imagePath';
    }

    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.blue.withValues(alpha: 0.8),
            Colors.blue.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Stack(
        children: [
          // ✅ IMAGE + OVERLAY
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image or fallback
                imagePath.isNotEmpty
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallback(title);
                        },
                      )
                    : _buildFallback(title),

                // ✅ Overlay for readability
                Container(color: Colors.black.withValues(alpha: 0.2)),
              ],
            ),
          ),

          // ✅ INDEX TAG
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.black, Colors.black.withValues(alpha: 0.3)],
                ),
              ),
              child: TextWidget(
                word: '#${index + 1}',
                textColor: Colors.white,
                weight: FontWeight.w800,
              ),
            ),
          ),

          // ✅ PRICE TAG
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: TextWidget(
                word: 'NRs $cost',
                size: 14,
                weight: FontWeight.w600,
              ),
            ),
          ),

          // ✅ RATING TAG
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.star, size: 16),
                  TextWidget(
                    word: ' $rating',
                    textColor: Colors.white,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallback(String title) {
    return Center(
      child: TextWidget(
        word: title.isNotEmpty ? title[0].toUpperCase() : '',
        size: 54,
        weight: FontWeight.w900,
        textColor: customColors.whiteBlack,
      ),
    );
  }
}
