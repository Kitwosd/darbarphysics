import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewMoreCardWidget extends StatelessWidget {
  final double? height;
  final VoidCallback onTap;
  final double? width;
  const ViewMoreCardWidget({
    super.key,
    this.height,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height?.h ?? 50.h,
          width: width?.h ?? 160.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
            color: appColors.primary.withValues(alpha: 0.05),
            border: Border.all(color: appColors.primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              TextWidget(
                word: 'View More',
                weight: FontWeight.w600,
                textColor: appColors.primary,
              ),
              6.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18.sp,
                color: appColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
