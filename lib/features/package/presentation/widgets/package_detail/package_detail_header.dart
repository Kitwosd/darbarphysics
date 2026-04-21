import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageDetailHeader extends StatelessWidget {
  final PackageDetailModel package;

  const PackageDetailHeader({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full width Header Image
        SizedBox(
          width: double.infinity,
          height: 220.h,
          child: Image.network(
            package.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 40),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                word: package.title,
                size: 22,
                weight: FontWeight.bold,
                maxLines: 2,
                textColor: appColors.primary,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _buildChip(
                    context,
                    '${package.courseCount} Courses',
                    Icons.book_outlined,
                    Colors.blue,
                  ),
                  SizedBox(width: 8.w),
                  _buildChip(
                    context,
                    'Lifetime Access',
                    Icons.access_time,
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha:0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          TextWidget(
            word: label,
            size: 11,
            weight: FontWeight.w600,
            textColor: color,
          ),
        ],
      ),
    );
  }
}
