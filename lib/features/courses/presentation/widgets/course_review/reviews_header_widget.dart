import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsHeaderWidget extends StatelessWidget {
  const ReviewsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 32.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        12.horizontalSpace,
        TextWidget(
          word: 'Students Reviews',
          weight: FontWeight.w900,
          size: 24,
          letterSpacing: 1,
        ),
      ],
    );
  }
}
