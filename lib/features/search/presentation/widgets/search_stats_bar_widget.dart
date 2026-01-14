import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchStatsBarWidget extends StatelessWidget {
  final SearchTab currentTab;
  final String query;
  final int videosCount;
  final int coursesCount;
  final int liveClassesCount;
  final int totalCount;
  const SearchStatsBarWidget({
    super.key,
    required this.currentTab,
    required this.query,
    required this.videosCount,
    required this.coursesCount,
    required this.liveClassesCount,
    required this.totalCount,
  });

  String get _statsText {
    switch (currentTab) {
      case SearchTab.all:
        return '$totalCount results';
      case SearchTab.courses:
        return '$coursesCount courses';
      case SearchTab.liveclasses:
        return '$liveClassesCount live classes';
      case SearchTab.videos:
        return '$videosCount videos';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          TextWidget(
            word: 'Showing',
            size: 14,
            textColor: Theme.of(context).hintColor,
          ),
          4.horizontalSpace,
          TextWidget(
            word: _statsText,
            size: 14,
            weight: FontWeight.bold,
            textColor: appColors.primary,
          ),
          4.horizontalSpace,
          TextWidget(
            word: 'for',
            size: 14,
            textColor: Theme.of(context).hintColor,
          ),
          4.horizontalSpace,
          Expanded(
            child: TextWidget(
              word: "'$query'",
              size: 14,
              weight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
