import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_state.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/videos_bookmark/videos_bookmark_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/saved_courses_list_widget.dart';
import 'package:durbar_physics/features/home/presentation/widgets/saved_videos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    // ✅ ADD THESE LINES:
    context.read<VideosBookmarkBloc>().add(LoadVideosEvent());
    context.read<CourseBookmarkBloc>().add(LoadBookmarkCoursesEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          word: "BOOKMARKS",
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
                BlocBuilder<VideosBookmarkBloc, VideosBookmarkState>(
                  builder: (context, state) {
                    return SavedVideosListWidget(videos: state.videos);
                  },
                ),
                BlocBuilder<CourseBookmarkBloc, CourseBookmarkState>(
                  builder: (context, state) {
                    return SavedCoursesListWidget(courses: state.courses);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation:
      floatingActionButton: SizedBox(
        width: 150.w,

        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            NavigationService.pushNamedReplacement(RouteName.home);
          },

          child: TextWidget(
            word: 'Add more',
            weight: FontWeight.w600,
            size: 18,
            textColor: customColors.whiteBlack,
          ),
        ),
      ),
    );
  }
}
