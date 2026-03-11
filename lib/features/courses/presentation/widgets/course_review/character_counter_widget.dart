import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CharacterCounterWidget extends StatelessWidget {
  final int characterCount;
  final bool isMinCharacterMet;

  const CharacterCounterWidget({
    super.key,
    required this.characterCount,
    required this.isMinCharacterMet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isMinCharacterMet
            ? (isDark
                  ? const Color(0xFF1B5E20).withValues(alpha: 0.3)
                  : const Color(0xFFF1F8F4))
            : (isDark ? Colors.grey[850] : const Color(0xFFF8F9FA)),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isMinCharacterMet
              ? const Color(0xFF4CAF50)
              : (isDark ? Colors.grey[700]! : Colors.transparent),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: isMinCharacterMet
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                  border: Border.all(
                    color: isMinCharacterMet
                        ? const Color(0xFF4CAF50)
                        : (isDark
                              ? Colors.grey[600]!
                              : const Color(0xFF999999)),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: isMinCharacterMet
                    ? Icon(Icons.check, size: 10.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 8.w),
              Text(
                'Minimum 10 characters',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isMinCharacterMet
                      ? const Color(0xFF4CAF50)
                      : (isDark ? Colors.grey[400] : const Color(0xFF999999)),
                ),
              ),
            ],
          ),
          Text(
            '$characterCount / ∞',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey[400] : const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}
