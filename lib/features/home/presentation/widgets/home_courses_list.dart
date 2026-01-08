import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/features/courses/presentation/courses/courses_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCoursesList extends StatelessWidget {
  const HomeCoursesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state.coursesList.isEmpty) {
          return const SizedBox.shrink();
        } else if (state.status == ApiDataStatus.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.status == ApiDataStatus.success) {
          return SizedBox(
            height: 240.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: state.coursesList.length,
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200.w,
                  child: CourseCard(course: state.coursesList[index]),
                );
              },
            ),
          );
        } else if (state.status == ApiDataStatus.error) {
          return SizedBox.shrink();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
