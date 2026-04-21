import 'package:durbar_physics/common/widgets/tab_scroll_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/package/data/model/package_course_model.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageDetailCoursesTab extends StatelessWidget {
  final PackageDetailModel package;

  const PackageDetailCoursesTab({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    // Calculate financial breakdown
    double totalValue = 0;
    for (var course in package.courses) {
      totalValue += double.tryParse(course.cost) ?? 0;
    }
    double currentPrice = double.tryParse(package.price) ?? 0;
    double savings = totalValue - currentPrice;

    return TabScrollWrapperWidget(
      child: CustomScrollView(
        primary: true,
        slivers: [
          SliverOverlapInjector(
            handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
              context,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCourseHeader(context),
                20.verticalSpace,
                ...package.courses.map(
                  (course) => _buildCourseItem(context, course),
                ),
                30.verticalSpace,
                _buildSavingsCard(context, totalValue, currentPrice, savings),
                100.verticalSpace, // Extra space for bottom bar
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          word: "What's Included",
          size: 18,
          weight: FontWeight.bold,
        ),
        SizedBox(height: 4.h),
        TextWidget(
          word: "All of the following courses are included in this package.",
          size: 13,
          textColor: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildCourseItem(BuildContext context, PackageCourse course) {
    return InkWell(
      onTap: () {
        NavigationService.pushNamed(RouteName.detailScreen, extra: course.id);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha:0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            _buildCheckmarkIcon(context),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    word: course.title,
                    size: 15,
                    weight: FontWeight.bold,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  TextWidget(
                    word: "Value: Rs. ${course.cost}",
                    size: 12,
                    textColor: Colors.grey[600],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: Image.network(
                // Handle relative paths if necessary, assume full URL for now
                course.image.startsWith('http')
                    ? course.image
                    : 'https://blog.durbarphysics.com${course.image}',
                height: 40.w,
                width: 50.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.school, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckmarkIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha:0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_circle,
        color: Theme.of(context).primaryColor,
        size: 16.sp,
      ),
    );
  }

  Widget _buildSavingsCard(
    BuildContext context,
    double totalValue,
    double currentPrice,
    double savings,
  ) {
    if (savings <= 0) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha:0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha:0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFinancialRow(
            "Total Combined Value",
            "Rs. ${totalValue.toStringAsFixed(2)}",
            Colors.white70,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: Colors.white24, thickness: 1),
          ),
          _buildFinancialRow(
            "Package Price",
            "Rs. ${currentPrice.toStringAsFixed(2)}",
            Colors.white,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  word: "Your Lifetime Savings",
                  weight: FontWeight.bold,
                  textColor: Colors.white,
                  size: 14,
                ),
                TextWidget(
                  word: "Rs. ${savings.toStringAsFixed(2)}",
                  weight: FontWeight.w900,
                  textColor: Colors.amberAccent,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(word: label, textColor: color, size: 14),
        TextWidget(
          word: value,
          weight: FontWeight.bold,
          textColor: color,
          size: 15,
        ),
      ],
    );
  }
}
