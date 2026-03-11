import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';

import 'package:durbar_physics/features/courses/presentation/widgets/course_review/review_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseOverviewTab extends StatefulWidget {
  final CourseDetailModel course;

  const CourseOverviewTab({super.key, required this.course});

  @override
  State<CourseOverviewTab> createState() => _CourseOverviewTabState();
}

class _CourseOverviewTabState extends State<CourseOverviewTab> {
  late final ScrollController _controller;
  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollBarWrapperWidget(
      controller: _controller,
      child: ListView(
        controller: _controller,
        // crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.all(20.w),
        children: [
          !widget.course.isUserLocked
              ? _userAlreadyEnrolledCard(context)
              : SizedBox.shrink(),
          24.verticalSpace,
          const TextWidget(
            word: "Introduction",
            size: 18,
            weight: FontWeight.bold,
          ),
          10.verticalSpace,
          TextWidget(
            word: widget.course.description,
            textColor: Theme.of(context).textTheme.bodyMedium?.color,
            maxLines: 50,
          ),
          24.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard(
                context,
                widget.course.rating.toString(),
                "Reviews",
                Icons.star,
                Colors.amber,
              ),
              SizedBox(width: 10.w),
              _buildStatCard(
                context,
                //TODO: to check if course is free not with cost zero
                (double.tryParse(widget.course.cost) ?? 0) == 0
                    ? 'Free Course'
                    : widget.course.studentCount.toString(),
                "Students",
                Icons.people,
                Colors.blue,
              ),
            ],
          ),

          24.verticalSpace,
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            thickness: 1,
          ),
          24.verticalSpace,

          ReviewSection(courseId: widget.course.id),

          24.verticalSpace,
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
    final isDark =
        Theme.of(context).brightness ==
        Brightness.dark; // ADDED: dark mode check
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          // CHANGED: replaced flat border with subtle shadow
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          // END CHANGED
        ),
        child: Row(
          children: [
            // ADDED: icon wrapped in tinted circle
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            // END ADDED
            SizedBox(width: 10.w),
            Expanded(
              // ADDED: Expanded to prevent text overflow on long values
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(word: value, weight: FontWeight.bold, size: 16),
                  TextWidget(word: label, textColor: Colors.grey, size: 12),
                ],
              ),
            ), // END ADDED
          ],
        ),
      ),
    );
  }
}
