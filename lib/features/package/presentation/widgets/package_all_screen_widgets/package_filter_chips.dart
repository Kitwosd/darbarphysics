import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const PackageFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const filters = [
    'All',
    'Grade 10',
    'Grade 11',
    'Grade 12',
    '+2 Science',
    'SEE',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha:0.5),
            width: 0.5,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withValues(alpha:0.1)
                    : Theme.of(context).colorScheme.surfaceContainerHigh,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor.withValues(alpha:0.5),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(alpha:0.7),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
