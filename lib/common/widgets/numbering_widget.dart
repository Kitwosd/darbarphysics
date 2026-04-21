import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumberingWidget extends StatelessWidget {
  final int index;
  const NumberingWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,

          colors: [Colors.black, Colors.black.withValues(alpha: 0.3)],
        ),
      ),

      child: TextWidget(
        size: 12,
        word: '#${index + 1}',
        textColor: Colors.white70,
        weight: FontWeight.w800,
      ),
    );
  }
}
