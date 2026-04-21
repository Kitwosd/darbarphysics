import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/search/presentation/bloc/search_bloc.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_result_list_widget.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_stats_bar_widget.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_tab_segment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SearchTab { all, courses, videos, liveclasses }

class SearchResultWidget extends StatefulWidget {
  const SearchResultWidget({super.key});

  @override
  State<SearchResultWidget> createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  SearchTab _currentTab = SearchTab.all;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.status == ApiDataStatus.loading) {
          return Center(
            child: SizedBox(
              height: 70.h,
              width: 70.w,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.status == ApiDataStatus.error) {
          return ErrorScreen(
            onGoHome: () =>
                NavigationService.pushNamedReplacement(RouteName.home),
            onRetry: () =>
                context.read<SearchBloc>().add(GetSearchedDataEvent(query: '')),
          );
        } else if (state.status == ApiDataStatus.success) {
          final totalResults =
              state.videos.length +
              state.courses.length +
              state.liveClasses.length;
          if (totalResults == 0) {
            return _buildNoResultState(state.query);
          }
          return Column(
            children: [
              //stats Bar
              SearchStatsBarWidget(
                currentTab: _currentTab,
                query: state.query,
                videosCount: state.videos.length,
                coursesCount: state.courses.length,
                liveClassesCount: state.liveClasses.length,
                totalCount: totalResults,
              ),
              SearchTabSegmentWidget(
                currentTab: _currentTab,
                videosCount: state.videos.length,
                coursesCount: state.courses.length,
                liveClassesCount: state.liveClasses.length,
                totalCount: totalResults,
                onTabChanged: (searchTab) {
                  setState(() {
                    _currentTab = searchTab;
                  });
                },
              ),

              //Result list
              Expanded(
                child: SearchResultListWidget(
                  currentTab: _currentTab,
                  videos: state.videos,
                  courses: state.courses,
                  liveClasses: state.liveClasses,
                ),
              ),
            ],
          );
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80.sp,
            color: Colors.grey.withValues(alpha: 0.8),
          ),
          16.verticalSpace,
          TextWidget(
            word: 'Start Searching',
            size: 20,
            weight: FontWeight.bold,
          ),
          8.verticalSpace,
          TextWidget(
            word: 'Find courses, videos, and live classes',
            size: 14,
            textColor: Theme.of(context).hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultState(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 80.sp,
            color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          TextWidget(
            word: 'No Results Found',
            size: 20,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          TextWidget(
            word: 'Try different keywords for "$query"',
            size: 14,
            textColor: Theme.of(context).hintColor,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
