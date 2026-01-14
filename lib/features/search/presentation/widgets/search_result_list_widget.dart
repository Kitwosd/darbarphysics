import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/data/models/video_model.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/search/presentation/widgets/course_result_item_widget.dart';
import 'package:durbar_physics/features/search/presentation/widgets/live_result_item_widget.dart';
import 'package:durbar_physics/features/search/presentation/widgets/search_result_widget.dart';
import 'package:durbar_physics/features/search/presentation/widgets/video_result_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultListWidget extends StatelessWidget {
  final SearchTab currentTab;
  final List<VideoModel> videos;
  final List<CourseModel> courses;
  final List<LiveClassModel> liveClasses;

  const SearchResultListWidget({
    super.key,
    required this.currentTab,
    required this.videos,
    required this.courses,
    required this.liveClasses,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (currentTab == SearchTab.all) {
      items = _buildMixedResults();
    } else if (currentTab == SearchTab.courses) {
      items = courses.map((c) => CourseResultItemWidget(course: c)).toList();
    } else if (currentTab == SearchTab.videos) {
      items = videos.map((v) => VideoResultItemWidget(video: v)).toList();
    } else if (currentTab == SearchTab.liveclasses) {
      items = liveClasses
          .map((l) => LiveResultItemWidget(liveClass: l))
          .toList();
    }
    return ListView.separated(
      padding: EdgeInsets.all(20.w),
      itemBuilder: (BuildContext context, int index) => items[index],
      separatorBuilder: (BuildContext context, int index) => 10.verticalSpace,
      itemCount: items.length,
    );
  }

  List<Widget> _buildMixedResults() {
    List<Widget> mixed = [];
    int videoIndex = 0;
    int courseIndex = 0;
    int liveIndex = 0;

    while (videoIndex < videos.length ||
        courseIndex < courses.length ||
        liveIndex < liveClasses.length) {
      //Add 2 videos
      for (int i = 0; i < 2 && videoIndex < videos.length; i++) {
        mixed.add(VideoResultItemWidget(video: videos[videoIndex++]));
      }
      //Add 1 course
      if (courseIndex < courses.length) {
        mixed.add(CourseResultItemWidget(course: courses[courseIndex++]));
      }

      //Add 1 live class
      if (liveIndex < liveClasses.length) {
        mixed.add(LiveResultItemWidget(liveClass: liveClasses[liveIndex++]));
      }

      //Add 1 more video

      if (videoIndex < videos.length) {
        mixed.add(VideoResultItemWidget(video: videos[videoIndex++]));
      }
    }
    return mixed;
  }
}
