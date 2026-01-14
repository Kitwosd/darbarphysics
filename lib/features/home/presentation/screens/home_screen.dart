import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_refresh_indicator.dart';
import 'package:durbar_physics/features/courses/presentation/courses/courses_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/home_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/streams/streams_bloc.dart';
import 'package:durbar_physics/features/home/presentation/bloc/videos/videos_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/home_banner.dart';
import 'package:durbar_physics/features/home/presentation/widgets/home_courses_list.dart';
import 'package:durbar_physics/features/home/presentation/widgets/home_header.dart';
import 'package:durbar_physics/features/home/presentation/widgets/home_search_bar.dart';
import 'package:durbar_physics/features/home/presentation/widgets/home_section_header.dart';
import 'package:durbar_physics/features/live_classes/presentation/bloc/live_classes_bloc.dart';
import 'package:durbar_physics/features/live_classes/presentation/widgets/home_live_classes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    context.read<HomeBloc>().add(GetHomeData());
    context.read<LiveClassesBloc>().add(GetLiveClassesEvent());
    context.read<CoursesBloc>().add(GetCoursesEvent());
    // await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<HomeBloc>()..add(GetHomeData()),
        ),

        BlocProvider(
          create: (context) => getIt<VideosBloc>()..add(GetVideosEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<StreamsBloc>()..add(GetStreamsEvent()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<LiveClassesBloc>()..add(GetLiveClassesEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return InkWell(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    const HomeHeader(),
                    Expanded(
                      child: AppRefreshIndicator(
                        onRefresh: () => _handleRefresh(context),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Column(
                            children: [
                              const HomeSearchBar(),
                              const HomeBanner(),

                              HomeSectionHeader(
                                title: 'Live Classes',
                                onSeeAll: () {
                                  context.push(RoutePath.liveClassesList);
                                },
                              ),
                              const HomeLiveClassesList(),
                              HomeSectionHeader(
                                title: 'Top Courses',
                                onSeeAll: () {},
                              ),
                              HomeCoursesList(),

                              BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, state) {
                                  // if (state.status == ApiDataStatus.loading) {
                                  //   return const Center(child: CircularProgressIndicator());
                                  // } else
                                  if (state.status == ApiDataStatus.error) {
                                    return Center(
                                      child: Text('Error: //${state.error}'),
                                    );
                                  } else if (state.status ==
                                      ApiDataStatus.success) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //HomeCategories(streams: state.streams),

                                        // if (state.videos.isNotEmpty) ...[
                                        //   HomeSectionHeader(
                                        //     title: 'Videos',
                                        //     onSeeAll: () {},
                                        //   ),
                                        //   HomeVideosList(),
                                        // ],

                                        // // Live Classes Logic managed by its own Bloc
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
