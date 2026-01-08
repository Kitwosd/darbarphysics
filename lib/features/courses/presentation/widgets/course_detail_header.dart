import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/core/hive_services/hive_mappers/course_hive_mapper.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseDetailHeader extends StatelessWidget {
  final CourseDetailModel course;

  const CourseDetailHeader({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseBookmarkBloc, CourseBookmarkState>(
      listenWhen: (previous, current) =>
          previous.courses.length != current.courses.length,
      listener: (context, state) {
        final isBookmarked = state.bookmarkIds.contains(course.id);
        OverlayToastWidget.show(
          message: isBookmarked ? 'Added to Bookmark' : 'Removed from Bookmark',
          bgColor: isBookmarked ? Colors.green.shade400 : Colors.red.shade700,
        );
      },
      child: Stack(
        children: [
          Image.network(
            course.image,
            height: 250.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(height: 250.h, color: Colors.grey[300]),
          ),
          Positioned(
            top: 10.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          BlocBuilder<CourseBookmarkBloc, CourseBookmarkState>(
            builder: (context, state) {
              final isBookmarked = state.bookmarkIds.contains(course.id);
              return Positioned(
                top: 10.h,
                right: 20.w,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      final bloc = context.read<CourseBookmarkBloc>();
                      if (isBookmarked) {
                        bloc.add(RemoveCourseEvent(courseId: course.id));
                      } else {
                        ////you maile courseModel base ma banaye so to rectify that as bookmark is in courseDetailModel we have this
                        bloc.add(
                          AddCourseEvent(course: course.toHive().toCourse()),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
