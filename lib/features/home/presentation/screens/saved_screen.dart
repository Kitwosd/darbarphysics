import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/home/presentation/widgets/saved_courses_list_widget.dart';
import 'package:durbar_physics/features/home/presentation/widgets/saved_videos_list_widget.dart';
import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mock saved list
    final List<CourseModel> savedCourses = [
      CourseModel(
        id: 1,
        title: "Adobe illustrator for all beginner artist",
        description: "Graphic design",
        cost: 10000,
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        image:
            "https://images.unsplash.com/photo-1626785774573-4b799314346d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
        createdAt: DateTime.now(),
      ),
      CourseModel(
        id: 2,
        title: "Digital illustration technique for procreate",
        description: "Graphic design",
        cost: 50000,
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        image:
            "https://images.unsplash.com/photo-1544531586-fde5298cdd40?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
        createdAt: DateTime.now(),
      ),
    ];
    final List<VideoModel> savedVideos = [
      VideoModel(
        id: 1,
        title: 'HEllo broo',
        teacher: 'Sanjay Chaudary',
        videoUrl: 'somevidoe',
        thumbnail: 'some picture',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          word: "My save list",
          weight: FontWeight.bold,
          size: 18,
          textColor:
              Theme.of(context).appBarTheme.titleTextStyle?.color ??
              Theme.of(context).textTheme.titleLarge?.color,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: appColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: appColors.primary,

            tabs: const [
              Tab(text: 'Videos'),
              Tab(text: 'Courses'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SavedVideosListWidget(videos: savedVideos),
                SavedCoursesListWidget(courses: savedCourses),
              ],
            ),
          ),
          FloatingActionButton(
            onPressed: () {},

            child: TextWidget(word: 'Add more'),
          ),
        ],
      ),
    );
  }
}
