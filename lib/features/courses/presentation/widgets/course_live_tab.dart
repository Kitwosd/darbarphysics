// ignore_for_file: unused_element

import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_live_class_card_widget.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseLiveTab extends StatefulWidget {
  final CourseDetailModel course;
  const CourseLiveTab({super.key, required this.course});

  @override
  State<CourseLiveTab> createState() => _CourseLiveTabState();
}

class _CourseLiveTabState extends State<CourseLiveTab> {
  final ScrollController _scrollController = ScrollController();

  List<LiveClassDetailModel> _getLiveClasses() {
    return widget.course.liveClasses.where((c) => c.status == 'live').toList();
  }

  List<LiveClassDetailModel> _getUpcomingClasses() {
    final upcoming = widget.course.liveClasses
        .where((c) => c.status == 'upcoming')
        .toList();
    // sort by start time - nearest first
    upcoming.sort((a, b) => a.startTime.compareTo(b.startTime));
    return upcoming;
  }

  List<LiveClassDetailModel> _getEndedClasses() {
    final ended = widget.course.liveClasses
        .where((c) => c.status == 'ended')
        .toList();
    //sort by end time - most recent first

    ended.sort((a, b) => b.endTime.compareTo(a.endTime));
    return ended;
  }

  @override
  Widget build(BuildContext context) {
    final liveClasses = _getLiveClasses();
    final upcomingClasses = _getUpcomingClasses();
    final endedClasses = _getEndedClasses();

    final allClassSorted = List<LiveClassDetailModel>.from(
      widget.course.liveClasses,
    )..sort((a, b) => a.startTime.compareTo(b.startTime));
    final Map<int, int> sessionNumberMap = {};
    for (int i = 0; i < allClassSorted.length; i++) {
      final classId = allClassSorted[i].id;
      final sessionNumber = i + 1;

      sessionNumberMap[classId] = sessionNumber;
    }
    if (widget.course.liveClasses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_camera_back_outlined,
              size: 80.w,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ],
        ),
      );
    }
    return ScrollBarWrapperWidget(
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.all(20.w),
        children: [
          //Live now Section
          if (liveClasses.isNotEmpty) ...[
            _buildSectionHeader(context, 'Live Now', Colors.red),
            12.verticalSpace,
            ...liveClasses.map(
              (liveClass) => CourseLiveClassCardWidget(
                liveClass: liveClass,
                isLive: true,
                sessionNumber: sessionNumberMap[liveClass.id]!,
              ),
            ),
            24.verticalSpace,
          ],

          if (upcomingClasses.isNotEmpty) ...[
            _buildSectionHeader(context, 'Upcoming', appColors.primary),
            12.verticalSpace,
            ...upcomingClasses.map(
              (upcoming) => CourseLiveClassCardWidget(
                liveClass: upcoming,
                isUpcoming: true,
                sessionNumber: sessionNumberMap[upcoming.id]!,
              ),
            ),
          ],

          if (endedClasses.isNotEmpty) ...[
            _buildSectionHeader(context, 'ENDED', Colors.grey),
            12.verticalSpace,
            ...endedClasses.map(
              (ended) => CourseLiveClassCardWidget(
                liveClass: ended,
                isEnded: true,
                sessionNumber: sessionNumberMap[ended.id]!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        8.verticalSpace,
        TextWidget(
          word: title,
          size: 18,
          weight: FontWeight.w900,
          textColor: customColors.blackWhite,
        ),
      ],
    );
  }
}
