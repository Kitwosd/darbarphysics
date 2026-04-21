import 'package:durbar_physics/features/package/data/model/package_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageSmallCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onTap;

  const PackageSmallCard({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: Image.network(
                package.image,
                width: double.infinity,
                height: 110.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 110.h,
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      package.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 6.h),

                    // Course Count & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Course Count
                        Text(
                          '📚 ${package.courseCount} courses',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 12.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                        ),

                        // Price
                      ],
                    ),
                    5.verticalSpace,
                    Text(
                      'Rs. ${_formatPrice(package.price)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 5.h),

                    // View Details Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 0.5,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        child: Text(
                          'View Details →',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
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
