import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';

import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/enrolled_courses/enrolled_courses_bloc.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/enrolled_course_card_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/enrolled_screen_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnrolledCourseScreen extends StatefulWidget {
  const EnrolledCourseScreen({super.key});

  @override
  State<EnrolledCourseScreen> createState() => _EnrolledCourseScreenState();
}

class _EnrolledCourseScreenState extends State<EnrolledCourseScreen> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return BlocProvider(
      create: (context) =>
          getIt<EnrolledCoursesBloc>()..add(GetEnrolledCoursesEvent()),
      child: BlocBuilder<EnrolledCoursesBloc, EnrolledCoursesState>(
        builder: (context, state) {
          if (state.status == ApiDataStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == ApiDataStatus.error) {
            return Builder(
              builder: (context) {
                return ErrorScreen(
                  onRetry: () => getIt<EnrolledCoursesBloc>().add(
                    GetEnrolledCoursesEvent(),
                  ),

                  onGoHome: () =>
                      NavigationService.pushNamedReplacement(RouteName.home),
                );
              },
            );
          } else if (state.status == ApiDataStatus.success) {
            int coursesNumber = state.enrolledCourses.length;
            return Builder(
              builder: (context) {
                return SafeArea(
                  child: Column(
                    children: [
                      EnrolledScreenHeaderWidget(coursesNumber: coursesNumber),
                      Expanded(
                        child: ScrollBarWrapperWidget(
                          controller: scrollController,
                          child: ListView.separated(
                            controller: scrollController,
                            padding: EdgeInsets.all(16.w),
                            // gridDelegate:
                            //     const SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 1,
                            //       childAspectRatio: 0.68,
                            //       crossAxisSpacing: 16,
                            //       mainAxisSpacing: 16,
                            //     ),
                            itemCount: state.enrolledCourses.length,
                            itemBuilder: (context, index) {
                              final course = state.enrolledCourses[index];
                              return EnrolledCourseCardWidget(
                                courseIndex: index,
                                course: course,
                                onTap: () {
                                  NavigationService.pushNamed(
                                    RouteName.detailScreen,
                                    extra: course.id,
                                  );
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                                  return 16.verticalSpace;
                                },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
    // return Center(child: TextWidget(word: 'Hello Broo'));
  }
}
