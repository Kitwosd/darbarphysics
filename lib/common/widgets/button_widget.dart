import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final TextWidget textWidget;
  final Function onPressed;
  final double? height;
  final double? width;
  final Color? bgcolor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? borderWidth;
  final Color? borderColor;

  const ButtonWidget({
    super.key,
    required this.textWidget,
    required this.onPressed,
    this.height,
    this.width,
    this.bgcolor,
    this.borderRadius,
    this.padding,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height?.h ?? 60.h,
      width: width?.w ?? double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor ?? AppColors.primary,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(borderRadius?.r ?? 8.r),
            side: borderWidth != null && borderColor != null
                ? BorderSide(width: borderWidth!.w, color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: textWidget,
      ),
    );
  }
}
