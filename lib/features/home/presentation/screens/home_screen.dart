import 'package:dubar_physics/core/di/injection.dart';
import 'package:dubar_physics/common/enums/enums.dart';
import 'package:dubar_physics/features/home/presentation/bloc/courses/courses_bloc.dart';
import 'package:dubar_physics/features/home/presentation/bloc/home_bloc.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_banner.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_categories.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_courses_list.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_header.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_search_bar.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_section_header.dart';
import 'package:dubar_physics/features/home/presentation/widgets/home_videos_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<HomeBloc>()..add(GetHomeData()),
        ),
        BlocProvider(
          create: (context) => getIt<CoursesBloc>()..add(GetCoursesEvent()),
        ),
      ],
      child: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                const HomeHeader(),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state.status == ApiDataStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == ApiDataStatus.error) {
                        return Center(child: Text('Error: //${state.error}'));
                      } else if (state.status == ApiDataStatus.success) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HomeSearchBar(),
                              const HomeBanner(),
                              HomeCategories(streams: state.streams),

                              HomeSectionHeader(
                                title: 'Top Courses',
                                onSeeAll: () {},
                              ),
                              HomeCoursesList(),

                              if (state.videos.isNotEmpty) ...[
                                HomeSectionHeader(
                                  title: 'Videos',
                                  onSeeAll: () {},
                                ),
                                HomeVideosList(videos: state.videos),
                              ],

                              // You can add LiveClasses List similar to VideosList if needed
                              if (state.liveClasses.isNotEmpty) ...[
                                HomeSectionHeader(
                                  title: 'Live Classes',
                                  onSeeAll: () {},
                                ),
                                // Placeholder for Live Classes List or reuse VideosList if structure similar
                                // HomeVideosList(videos: state.liveClasses...)
                              ],
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
