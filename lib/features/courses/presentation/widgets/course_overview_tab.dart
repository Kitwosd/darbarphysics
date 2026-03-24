import 'package:durbar_physics/common/widgets/tab_scroll_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/review_section.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CourseOverviewTab extends StatefulWidget {
  final CourseDetailModel course;

  const CourseOverviewTab({super.key, required this.course});

  @override
  State<CourseOverviewTab> createState() => _CourseOverviewTabState();
}

class _CourseOverviewTabState extends State<CourseOverviewTab>
    with AutomaticKeepAliveClientMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TabScrollWrapperWidget(
      child: CustomScrollView(
        primary: true,
        // physics: const BouncingScrollPhysics(
        //   parent: AlwaysScrollableScrollPhysics(),
        // ),
        slivers: [
          //1. Inject the space of the pinned TabBar
          SliverOverlapInjector(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
              context,
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),

            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                _buildDescription(context),
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
                ReviewSection(
                  courseId: widget.course.id,
                  isUserLocked: widget.course.isUserLocked,
                ),

                24.verticalSpace,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    // Determine if description is long enough to warrant show more
    final bool isLong = widget.course.description.length > 300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              constraints: !_isExpanded && isLong
                  ? BoxConstraints(maxHeight: 150.h)
                  : null,
              child: ClipRect(
                child: HtmlWidget(
                  widget.course.description,
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            if (!_isExpanded && isLong)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 0),
                        Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 0.9),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextWidget(
                    word: _isExpanded ? "Show Less" : "Show More",
                    weight: FontWeight.bold,
                    textColor: Theme.of(context).primaryColor,
                    size: 14,
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
      ],
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

  @override
  bool get wantKeepAlive => true;
}
