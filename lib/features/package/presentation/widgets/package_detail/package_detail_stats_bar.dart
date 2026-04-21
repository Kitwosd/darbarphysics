import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageDetailStatsBar extends StatelessWidget {
  final PackageDetailModel package;

  const PackageDetailStatsBar({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            'Rs. ${package.price}',
            'Price',
            Icons.sell_outlined,
            Theme.of(context).primaryColor,
          ),
          Container(
            height: 30.h,
            width: 1,
            color: Theme.of(context).dividerColor.withValues(alpha:0.5),
          ),
          _buildStatItem(
            context,
            '${package.courseCount}',
            'Total Courses',
            Icons.school_outlined,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 6.w),
            TextWidget(
              word: value,
              size: 16,
              weight: FontWeight.bold,
              textColor: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        TextWidget(
          word: label,
          size: 10,
          weight: FontWeight.w500,
          textColor: Colors.grey,
        ),
      ],
    );
  }
}
