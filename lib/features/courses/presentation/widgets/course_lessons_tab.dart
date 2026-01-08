import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';

import 'package:durbar_physics/features/courses/presentation/screens/video_player_screen.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseLessonsTab extends StatelessWidget {
  final CourseDetailModel course;

  const CourseLessonsTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: course.lessons.length,
      padding: EdgeInsets.all(20.w),
      itemBuilder: (context, index) {
        final lesson = course.lessons[index];
        return _buildLessonItem(context, lesson, index);
      },
    );
  }

  Widget _buildLessonItem(BuildContext context, VideoModel lesson, int index) {
    return InkWell(
      onTap: () {
        if (lesson.isLocked == true) {
          OverlayToastWidget.show(
            message: 'Please enroll to unlock the lesson',
          );
          // ToastWidget.show(
          //   text: 'Please enroll to unlock the lesson',
          //   position: ToastPosition.top,
          // );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text("Please enroll to unlock this lesson"),
          //   ),
          // );
        } else {
          // Play Video
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                video: lesson,
                videoUrl: lesson.videoUrl,
                title: lesson.title,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        child: Row(
          children: [
            Container(
              width: 45.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: TextWidget(
                  word: "${index + 1}",
                  weight: FontWeight.bold,
                  textColor: Colors.grey,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    word: lesson.title,
                    weight: FontWeight.bold,
                    maxLines: 2,
                    textColor: lesson.isLocked == true
                        ? Colors.grey
                        : customColors.blackWhite,
                  ),
                  TextWidget(
                    word: lesson.duration,
                    textColor: Colors.grey,
                    size: 12,
                  ),
                ],
              ),
            ),
            Icon(
              lesson.isLocked == true ? Icons.lock : Icons.play_circle_fill,
              color: lesson.isLocked
                  ? Colors.grey
                  : Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
