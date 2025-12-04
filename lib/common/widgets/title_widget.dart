import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54.h,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                size: 36.h, // set size manually
                color: AppColors.primary,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextWidget(
              word: title,
              size: 40.sp,
              weight: FontWeight.w600,
              textColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
