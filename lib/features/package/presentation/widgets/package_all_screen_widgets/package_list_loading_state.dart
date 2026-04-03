import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageListLoadingState extends StatelessWidget {
  const PackageListLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      itemCount: 5,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildShimmerCard(context);
      },
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? Colors.grey[800]!
        : Colors.grey[300]!;
    final highlightColor = isDark
        ? Colors.grey[700]!
        : Colors.grey[100]!;

    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha:0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // Image Shimmer
          Container(
            width: 120.w,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
            child: _buildShimmerEffect(baseColor, highlightColor),
          ),

          // Content Shimmer
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Line 1
                      Container(
                        height: 15.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: _buildShimmerEffect(baseColor, highlightColor),
                      ),
                      SizedBox(height: 6.h),

                      // Title Line 2
                      Container(
                        height: 15.h,
                        width: 0.7.sw - 150.w,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: _buildShimmerEffect(baseColor, highlightColor),
                      ),
                      SizedBox(height: 8.h),

                      // Info Chips
                      Row(
                        children: [
                          Container(
                            height: 11.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: _buildShimmerEffect(baseColor, highlightColor),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            height: 11.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: _buildShimmerEffect(baseColor, highlightColor),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Bottom Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: _buildShimmerEffect(baseColor, highlightColor),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 10.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: baseColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: _buildShimmerEffect(baseColor, highlightColor),
                          ),
                        ],
                      ),
                      Container(
                        height: 32.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: _buildShimmerEffect(baseColor, highlightColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect(Color baseColor, Color highlightColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 1500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                value - 0.3,
                value,
                value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop animation
      },
    );
  }
}