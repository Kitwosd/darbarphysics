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
      appBar: CustomAppbarWidget(title: 'All Courses'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  if (state.status == ApiDataStatus.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.status == ApiDataStatus.error) {
                    return ErrorScreen(
                      onGoHome: () => NavigationService.pushNamedReplacement(
                        RouteName.home,
                      ),
                      onRetry: () =>
                          context.read<CoursesBloc>().add(GetCoursesEvent()),
                    );
                  } else if (state.status == ApiDataStatus.success) {
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
                                course: state.coursesList[index],
                                index: index,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return 10.verticalSpace;
                            },
                            itemCount: state.coursesList.length,
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
