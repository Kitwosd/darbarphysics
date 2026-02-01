// ignore_for_file: unused_element

import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_detail_model.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_live_class_card_widget.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/cupertino.dart';
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

  // TEMPORARY: Dummy data for testing
  List<LiveClassDetailModel> _getDummyLiveClasses() {
    final now = DateTime.now();
    return [
      // Live class
      LiveClassDetailModel(
        id: 1,
        title: 'Introduction to Quantum Physics - Live Session',
        course: widget.course.id,
        startTime: now.subtract(const Duration(minutes: 15)),
        endTime: now.add(const Duration(hours: 1)),
        meetingUrl: 'https://zoom.us/j/123456789',
        description: 'Understanding quantum mechanics basics',
        isRecorded: true,
        recordingUrl: '',
        createdAt: now.subtract(const Duration(days: 2)),
        isLive: true,
        willStartSoon: false,
        thumbnail:
            'https://images.unsplash.com/photo-1761839271800-f44070ff0eb9?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        teacher: 'Dr. Prashant Durbar',
        status: 'live',
        isUserLocked: false,
        level: 1,
        subject: 1,
      ),

      // Upcoming - Today (2 hours from now)
      LiveClassDetailModel(
        id: 2,
        title: 'Problem Solving Session - Electricity & Magnetism',
        course: widget.course.id,
        startTime: now.add(const Duration(hours: 2)),
        endTime: now.add(const Duration(hours: 3, minutes: 30)),
        meetingUrl: 'https://zoom.us/j/987654321',
        description: 'Solving complex problems',
        isRecorded: false,
        recordingUrl: '',
        createdAt: now.subtract(const Duration(days: 1)),
        isLive: false,
        willStartSoon: true,
        thumbnail: '',
        teacher: 'Dr. Prashant Durbar',
        status: 'upcoming',
        isUserLocked: false,
        level: 1,
        subject: 1,
      ),

      // Upcoming - Tomorrow
      LiveClassDetailModel(
        id: 3,
        title: 'Wave Motion and Sound - Interactive Class',
        course: widget.course.id,
        startTime: now.add(const Duration(days: 1, hours: 10)),
        endTime: now.add(const Duration(days: 1, hours: 12)),
        meetingUrl: 'https://meet.google.com/abc-defg-hij',
        description: 'Deep dive into wave mechanics',
        isRecorded: true,
        recordingUrl: '',
        createdAt: now.subtract(const Duration(hours: 12)),
        isLive: false,
        willStartSoon: false,
        thumbnail:
            'https://images.unsplash.com/photo-1761839271800-f44070ff0eb9?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        teacher: 'Dr. Sarah Johnson',
        status: 'upcoming',
        isUserLocked: false,
        level: 1,
        subject: 1,
      ),

      // Upcoming - Locked (3 days from now)
      LiveClassDetailModel(
        id: 4,
        title: 'Advanced Thermodynamics - Premium Session',
        course: widget.course.id,
        startTime: now.add(const Duration(days: 3, hours: 14)),
        endTime: now.add(const Duration(days: 3, hours: 16)),
        meetingUrl: '',
        description: 'For enrolled students only',
        isRecorded: true,
        recordingUrl: '',
        createdAt: now.subtract(const Duration(hours: 6)),
        isLive: false,
        willStartSoon: false,
        thumbnail: '',
        teacher: 'Dr. Prashant Durbar',
        status: 'upcoming',
        isUserLocked: true,
        level: 1,
        subject: 1,
      ),

      // Ended - Yesterday (with recording)
      LiveClassDetailModel(
        id: 5,
        title: 'Newton\'s Laws of Motion - Recorded',
        course: widget.course.id,
        startTime: now.subtract(const Duration(days: 1, hours: 10)),
        endTime: now.subtract(const Duration(days: 1, hours: 8)),
        meetingUrl: '',
        description: 'Complete overview of Newton\'s laws',
        isRecorded: true,
        recordingUrl: 'https://vimeo.com/recording123',
        createdAt: now.subtract(const Duration(days: 5)),
        isLive: false,
        willStartSoon: false,
        thumbnail: '',
        teacher: 'Dr. Prashant Durbar',
        status: 'ended',
        isUserLocked: false,
        level: 1,
        subject: 1,
      ),

      // Ended - 3 days ago (no recording)
      LiveClassDetailModel(
        id: 6,
        title: 'Circular Motion Fundamentals',
        course: widget.course.id,
        startTime: now.subtract(const Duration(days: 3, hours: 15)),
        endTime: now.subtract(const Duration(days: 3, hours: 13)),
        meetingUrl: '',
        description: 'Basic concepts of circular motion',
        isRecorded: false,
        recordingUrl: '',
        createdAt: now.subtract(const Duration(days: 7)),
        isLive: false,
        willStartSoon: false,
        thumbnail: '',
        teacher: 'Dr. Michael Chen',
        status: 'ended',
        isUserLocked: false,
        level: 1,
        subject: 1,
      ),

      // Ended - Last week (locked)
      LiveClassDetailModel(
        id: 7,
        title: 'Optics - Advanced Concepts',
        course: widget.course.id,
        startTime: now.subtract(const Duration(days: 7, hours: 14)),
        endTime: now.subtract(const Duration(days: 7, hours: 12)),
        meetingUrl: '',
        description: 'Premium content for enrolled students',
        isRecorded: true,
        recordingUrl: 'https://vimeo.com/recording456',
        createdAt: now.subtract(const Duration(days: 10)),
        isLive: false,
        willStartSoon: false,
        thumbnail: '',
        teacher: 'Dr. Prashant Durbar',
        status: 'ended',
        isUserLocked: true,
        level: 1,
        subject: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final liveClasses = _getLiveClasses();
    // final upcomingClasses = _getUpcomingClasses();
    // final endedClasses = _getEndedClasses();

    final allClassSorted = List<LiveClassDetailModel>.from(
      //TODO: change this to widget.course.liveClasses
      _getDummyLiveClasses(),
    )..sort((a, b) => a.startTime.compareTo(b.startTime));
    final Map<int, int> sessionNumberMap = {};
    for (int i = 0; i < allClassSorted.length; i++) {
      final classId = allClassSorted[i].id;
      final sessionNumber = i + 1;

      sessionNumberMap[classId] = sessionNumber;
    }
    //TODO: remove the talw talw ko and mathi ko dummy data after the simulation
    final dummyClasses = _getDummyLiveClasses();

    final liveClasses = dummyClasses.where((c) => c.status == 'live').toList();

    final upcomingClasses =
        dummyClasses
            .where((c) => c.status != 'live' && c.status != 'ended')
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final endedClasses = dummyClasses.where((c) => c.status == 'ended').toList()
      ..sort((a, b) => b.endTime.compareTo(a.endTime));

    // if (course.liveClasses.isEmpty) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.video_camera_back_outlined,
    //           size: 80.w,
    //           color: Colors.grey.withValues(alpha: 0.5),
    //         ),
    //       ],
    //     ),
    //   );
    // }
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
