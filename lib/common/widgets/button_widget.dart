import 'package:durbar_physics/common/widgets/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatelessWidget {
  final TextWidget textWidget;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color? bgColor;
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
    this.bgColor,
    this.borderRadius,
    this.padding,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).elevatedButtonTheme.style;
    return SizedBox(
      height: height?.h ?? 60.h,
      width: width?.w ?? double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? baseStyle?.backgroundColor?.resolve({}),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius?.r ?? 8.r),
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
