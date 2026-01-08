import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedCoursesListWidget extends StatelessWidget {
  final List<CourseModel> courses;
  const SavedCoursesListWidget({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Slidable(
          key: ValueKey(course.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  context.read<CourseBookmarkBloc>().add(
                    RemoveCourseEvent(courseId: course.id),
                  );
                  OverlayToastWidget.show(
                    message: 'Course removed from bookmarks',
                  );
                },
                backgroundColor: Colors.red.shade600,
                icon: Icons.delete,
                label: 'Remove',
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(12.r),
                ),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => NavigationService.pushNamed(
              RouteName.detailScreen,
              extra: course.id,
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 15.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      courses[index].image,
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 80.h,
                        width: 80.w,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          word: courses[index].title,
                          maxLines: 2,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: 5.h),
                        TextWidget(
                          word: "Samule Doe",
                          textColor: Colors.grey,
                          size: 12,
                        ), // Mock
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14.sp, color: Colors.grey),
                            TextWidget(
                              word: " 4k student",
                              textColor: Colors.grey,
                              size: 12,
                            ),
                            SizedBox(width: 10.w),
                            Icon(Icons.star, size: 14.sp, color: Colors.amber),
                            TextWidget(
                              word: " 4.7",
                              textColor: Colors.grey,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
