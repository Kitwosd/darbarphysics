import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_Widget.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/services/pagination_wrapper_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/courses/courses_bloc.dart';
import 'package:durbar_physics/features/search/presentation/widgets/course_result_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWidget(
        title: 'All Courses',
        actions: [
          BlocBuilder<CoursesBloc, CoursesState>(
            builder: (context, state) {
              return PopupMenuButton<CourseSortOrder>(
                icon: Icon(
                  Icons.sort,
                  color: Theme.of(context).iconTheme.color,
                ),
                onSelected: (sortOrder) {
                  context.read<CoursesBloc>().add(
                    ChangeCourseSortEvent(sortOrder),
                  );
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem(
                    context,
                    CourseSortOrder.newest,
                    'Newest',
                    Icons.new_releases,
                    state.sortOrder,
                  ),
                  _buildSortMenuItem(
                    context,
                    CourseSortOrder.priceLowToHigh,
                    'Price: Low to High',
                    Icons.arrow_upward,
                    state.sortOrder,
                  ),
                  _buildSortMenuItem(
                    context,
                    CourseSortOrder.priceHighToLow,
                    'Price: High to Low',
                    Icons.arrow_downward,
                    state.sortOrder,
                  ),
                  _buildSortMenuItem(
                    context,
                    CourseSortOrder.mostPopular,
                    'Most Popular',
                    Icons.trending_up,
                    state.sortOrder,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(color: Theme.of(context).dividerColor, height: 1),
            Expanded(
              child: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  if (state.status == ApiDataStatus.loading &&
                      state.coursesList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == ApiDataStatus.error &&
                      state.coursesList.isEmpty) {
                    return ErrorScreen(
                      onGoHome: () => NavigationService.pushNamedReplacement(
                        RouteName.home,
                      ),
                      onRetry: () =>
                          context.read<CoursesBloc>().add(GetCoursesEvent()),
                    );
                  } else if (state.status == ApiDataStatus.success ||
                      state.coursesList.isNotEmpty) {
                    final courses = state.filteredAndSortedCourses;
                    return PaginationWrapperWidget(
                      onLoadMore: () {
                        context.read<CoursesBloc>().add(CourseLoadMoreEvent());
                      },
                      hasReachedMax: state.hasReachedMax,
                      builder: (ScrollController controller) {
                        return ScrollBarWrapperWidget(
                          controller: controller,
                          child: ListView.separated(
                            controller: controller,
                            padding: EdgeInsets.all(16.w),
                            itemBuilder: (context, index) {
                              return CourseResultItemWidget(
                                height: 100.h,
                                width: 120.w,
                                course: courses[index],
                                index: index,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return 10.verticalSpace;
                            },
                            itemCount: courses.length,
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<CourseSortOrder> _buildSortMenuItem(
    BuildContext context,
    CourseSortOrder value,
    String label,
    IconData icon,
    CourseSortOrder currentSort,
  ) {
    final isSelected = currentSort == value;
    return PopupMenuItem<CourseSortOrder>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
