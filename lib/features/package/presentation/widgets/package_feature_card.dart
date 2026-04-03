import 'package:durbar_physics/features/package/data/model/package_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageFeaturedCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onTap;
  final VoidCallback onEnroll;

  const PackageFeaturedCard({
    super.key,
    required this.package,
    required this.onTap,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1F9E75).withValues(alpha: 0.15),
                    const Color(0xFF1F9E75).withValues(alpha: 0.05),
                  ]
                : [
                    const Color(0xFF1F9E75).withValues(alpha: 0.08),
                    const Color(0xFF1F9E75).withValues(alpha: 0.03),
                  ],
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Featured Badge
            _buildImageSection(context),

            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      package.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 6.h),

                    // Description
                    Text(
                      package.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 12.h),

                    // Course Count & Level
                    Row(
                      children: [
                        _buildInfoChip(
                          context,
                          icon: '📚',
                          text: '${package.courseCount} courses',
                          isPrimary: true,
                        ),
                        SizedBox(width: 16.w),
                        //TODO: if level is asked to apply put it here.
                        //     _buildInfoChip(
                        //       context,
                        //       icon: '🎓',
                        //       text: 'SEE to +2',
                        //       isPrimary: false,
                        //     ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Price & Savings
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Rs. ${_formatPrice(package.price)}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        // if (savings > 0) ...[
                        //   SizedBox(width: 8.w),
                        //   Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 8.w,
                        //       vertical: 2.h,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xFF1F9E75).withValues(alpha:0.1),
                        //       borderRadius: BorderRadius.circular(4.r),
                        //     ),
                        //     child: Text(
                        //       'Save Rs. ${_formatPrice(savings.toString())}',
                        //       style: Theme.of(context).textTheme.bodySmall
                        //           ?.copyWith(
                        //             fontSize: 12.sp,
                        //             color: const Color(0xFF1F9E75),
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //     ),
                        //   ),
                        // ],
                      ],
                    ),

                    const Spacer(),

                    // Enroll Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onEnroll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Enroll Now →',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            child: Image.network(
              package.image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                );
              },
            ),
          ),

          // Gradient Overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),

          // Featured Badge
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1F9E75).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '🌟 FEATURED',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required String icon,
    required String text,
    required bool isPrimary,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: 12.sp)),
        SizedBox(width: 4.w),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 13.sp,
            fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
            color: isPrimary
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  String _formatPrice(String price) {
    final value = double.tryParse(price) ?? 0;
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

 
}
