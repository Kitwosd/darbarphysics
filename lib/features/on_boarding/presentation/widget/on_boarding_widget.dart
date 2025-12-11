import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingWidget extends StatelessWidget {
  final String svgImage;
  final String title;
  final String subTitle;
  const OnBoardingWidget({
    required this.svgImage,
    required this.title,
    required this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Expanded(
            child: svgImage.endsWith('.svg')
                ? SvgPicture.asset(svgImage)
                : Image.asset(svgImage),
          ),
          50.verticalSpace,
          TextWidget(
            word: title,
            size: 32,
            align: TextAlign.center,
            weight: FontWeight.w600,
            maxLines: 2,
          ),
          20.verticalSpace,
          TextWidget(
            word: subTitle,
            size: 14,
            align: TextAlign.center,
            weight: FontWeight.w400,
            maxLines: 2,
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
