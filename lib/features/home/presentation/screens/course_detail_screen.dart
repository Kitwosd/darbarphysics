import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/features/home/data/models/course_model.dart';
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
            _buildHeader(context),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          TextWidget(
                            word: widget.course.title,
                            size: 22,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_filled,
                                size: 16.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5.w),
                              const TextWidget(
                                word: "5 Hours 30 min",
                                textColor: Colors.grey,
                                size: 12,
                              ), // Mock data
                              SizedBox(width: 15.w),
                              Icon(
                                Icons.video_library,
                                size: 16.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5.w),
                              const TextWidget(
                                word: "20 Lessons",
                                textColor: Colors.grey,
                                size: 12,
                              ), // Mock data
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16.sp,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 5.w),
                              const TextWidget(
                                word: "4.7 (753)",
                                weight: FontWeight.bold,
                                size: 12,
                              ), // Mock data
                              SizedBox(width: 15.w),
                              Icon(
                                Icons.person,
                                size: 16.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 5.w),
                              const TextWidget(
                                word: "2k Students",
                                textColor: Colors.grey,
                                size: 12,
                              ), // Mock data
                            ],
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
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
                        children: [_buildOverview(), _buildLessons()],
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

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.course.image,
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
        Positioned(
          top: 10.h,
          right: 20.w,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.bookmark_border, color: Colors.black),
              onPressed: () {},
            ),
          ),
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
    );
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            word: "Introduction",
            size: 18,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 10.h),
          TextWidget(
            word: widget.course.description,
            textColor: Theme.of(context).textTheme.bodyMedium?.color,
            maxLines: 10,
          ),
          SizedBox(height: 20.h),
          // Mock Reviews
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard("4.7", "Reviews", Icons.star, Colors.amber),
              SizedBox(width: 10.w),
              _buildStatCard("753", "Students", Icons.people, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(word: value, weight: FontWeight.bold, size: 16),
                TextWidget(word: label, textColor: Colors.grey, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessons() {
    return ListView.builder(
      itemCount: 10, // Mock
      padding: EdgeInsets.all(20.w),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 15.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // Adjusted for theme
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: TextWidget(
                  word: "${index + 1}",
                  weight: FontWeight.bold,
                  textColor: Colors.grey,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      word: "Introduction to ${widget.course.title}",
                      weight: FontWeight.bold,
                    ),
                    const TextWidget(
                      word: "04:30 min",
                      textColor: Colors.grey,
                      size: 12,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_fill,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
