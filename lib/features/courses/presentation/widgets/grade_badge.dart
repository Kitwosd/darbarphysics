import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeBadge extends StatelessWidget {
  final String grade;
  const GradeBadge({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEEDFE),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
        border: Border(
          left: BorderSide(color: const Color(0xFF534AB7), width: 3.w),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎓', style: TextStyle(fontSize: 16.sp)),
          6.horizontalSpace,
          Text(
            grade.toUpperCase(), // e.g. "GRADE 10"
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3C3489),
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
