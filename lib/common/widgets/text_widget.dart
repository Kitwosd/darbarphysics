import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  final String word;
  final double? size;
  final Color? textColor;
  final FontWeight? weight;
  final TextOverflow? overflow;
  final TextAlign? align;
  final int? maxLines;
  const TextWidget({
    super.key,
    required this.word,
    this.size,
    this.textColor,
    this.weight,
    this.overflow,
    this.align,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      word,
      maxLines: maxLines, // null means unlimited lines
      textAlign: align ?? TextAlign.start,
      overflow: overflow ?? TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: size?.sp ?? 16.sp,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );
  }
}
