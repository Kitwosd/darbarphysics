import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingLabel extends StatelessWidget {
  final double rating;
  const RatingLabel({super.key, required this.rating});

  static const Map<int, String> ratingLabels = {
    1: '😞 Poor',
    2: '😕 Fair',
    3: '😊 Good',
    4: '😃 Very Good',
    5: '🤩 Excellent!',
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: rating > 0
            ? Text(
                ratingLabels[rating]!,
                key: ValueKey(rating),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF667EEA),
                  letterSpacing: 0.5,
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
