import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/view_more_card_widget.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/courses/courses_bloc.dart';
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
        if (state.status == ApiDataStatus.loading) {
          return SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator(color: Colors.blue)),
          );
        } else if (state.status == ApiDataStatus.success) {
          return SizedBox(
            height: 244.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: state.coursesList.length + 1,
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                if (index == state.coursesList.length) {
                  if (state.hasReachedMax == true) {
                    return SizedBox.shrink();
                  }
                  return ViewMoreCardWidget(
                    onTap: () {
                      context.read<CoursesBloc>().add(CourseLoadMoreEvent());
                    },
                  );
                }
                return SizedBox(
                  width: 200.w,
                  child: CourseCard(course: state.coursesList[index]),
                );
              },
            ),
          );
        } else if (state.status == ApiDataStatus.error) {
          return SizedBox(
            height: 80,
            child: Center(child: TextWidget(word: 'Something went wrong')),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
