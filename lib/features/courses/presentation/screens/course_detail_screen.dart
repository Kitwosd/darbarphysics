import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/features/courses/data/model/course_model.dart';
import 'package:dubar_physics/features/courses/presentation/widgets/course_detail_header.dart';
import 'package:dubar_physics/features/courses/presentation/widgets/course_info_section.dart';
import 'package:dubar_physics/features/courses/presentation/widgets/course_lessons_tab.dart';
import 'package:dubar_physics/features/courses/presentation/widgets/course_overview_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CourseDetailHeader(course: widget.course),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  CourseInfoSection(course: widget.course),
                ],
                body: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: const [
                        Tab(text: "Overview"),
                        Tab(text: "Lessons"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          CourseOverviewTab(course: widget.course),
                          CourseLessonsTab(course: widget.course),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.w),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: const TextWidget(
            word: "Enroll Now",
            size: 18,
            textColor: Colors.white,
            weight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
