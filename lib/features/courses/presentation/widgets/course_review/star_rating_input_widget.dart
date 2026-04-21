import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarRatingInputWidget extends StatelessWidget {
  final double selectedRating;
  final ValueChanged<double> onRatingSelected;
  const StarRatingInputWidget({
    super.key,
    required this.selectedRating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey[800]!, Colors.grey[850]!]
              : [const Color(0xFFF5F7FA), const Color(0xFFC3CFE2)],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          double rating = index + 1;
          final isActive = rating <= selectedRating;

          return IconButton(
            splashColor: Colors.amber.withValues(alpha: 0.2),

            onPressed: () => onRatingSelected(rating),
            icon: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isActive ? 1.25 : 1.0,
              curve: Curves.bounceIn,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: TextWidget(
                  word: '★',
                  size: 28,
                  textColor: isActive
                      ? Colors.amber
                      : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
