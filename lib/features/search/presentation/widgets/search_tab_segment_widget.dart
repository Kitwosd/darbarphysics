// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTabSegmentWidget extends StatelessWidget {
  final SearchTab currentTab;

  final int videosCount;
  final int coursesCount;
  final int liveClassesCount;
  final int totalCount;
  final Function(SearchTab) onTabChanged;
  const SearchTabSegmentWidget({
    super.key,
    required this.currentTab,

    required this.videosCount,
    required this.coursesCount,
    required this.liveClassesCount,
    required this.totalCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            _buildSegment(
              context,
              SearchTab.all,
              'All',
              '$totalCount results ',
            ),
            _buildSegment(
              context,
              SearchTab.courses,
              'Courses',
              '$coursesCount results ',
            ),
            _buildSegment(
              context,
              SearchTab.videos,
              'Videos',
              '$videosCount results',
            ),
            _buildSegment(
              context,
              SearchTab.liveclasses,
              'Live',
              '$liveClassesCount results',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegment(
    BuildContext context,
    SearchTab searchTab,
    String label,
    String count,
  ) {
    final isActive = currentTab == searchTab;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => onTabChanged(searchTab),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).scaffoldBackgroundColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: appColors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  word: label,
                  size: 15,
                  weight: FontWeight.w600,
                  textColor: isActive
                      ? appColors.primary
                      : Theme.of(context).hintColor,
                ),
                2.verticalSpace,
                TextWidget(
                  word: count,
                  size: 12,
                  textColor: isActive
                      ? appColors.primary.withValues(alpha: 0.7)
                      : Theme.of(context).hintColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
