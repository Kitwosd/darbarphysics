import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/custom_appbar_Widget.dart';
import 'package:durbar_physics/common/widgets/enrollment_dialog_widget.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/services/pagination_wrapper_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/routes/video_player_args.dart';
import 'package:durbar_physics/features/home/presentation/bloc/videos/videos_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/home_video_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllVideosScreen extends StatelessWidget {
  const AllVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (contextBloc) => getIt<VideosBloc>()..add(GetVideosEvent()),
      child: Scaffold(
        appBar: CustomAppbarWidget(title: 'All Videos'),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Theme.of(context).dividerColor),
              Expanded(
                child: BlocBuilder<VideosBloc, VideosState>(
                  builder: (context, state) {
                    return Builder(
                      builder: (context) {
                        if (state.status == ApiDataStatus.loading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state.status == ApiDataStatus.error) {
                          return ErrorScreen(
                            onGoHome: () =>
                                NavigationService.pushNamed(RouteName.home),
                            onRetry: () =>
                                context.read<VideosBloc>()
                                  ..add(GetVideosEvent()),
                          );
                        } else if (state.status == ApiDataStatus.success) {
                          return PaginationWrapperWidget(
                            onLoadMore: () {
                              context.read<VideosBloc>().add(
                                LoadMoreVideosEvent(),
                              );
                            },
                            hasReachedMax: state.hasReachedMax,
                            builder: (ScrollController controller) {
                              return ScrollBarWrapperWidget(
                                controller: controller,
                                child: ListView.separated(
                                  controller: controller,
                                  itemBuilder: (context, index) {
                                    final video = state.videos[index];
                                    return HomeVideoCardWidget(
                                      video: video,
                                      videoIndex: index,
                                      onTap: () {
                                        if (video.isUserLocked) {
                                          //TODO: course id not available so can't go to the course detail page.
                                          EnrollmentDialogWidget.show(
                                            context,
                                            onGoToCourse: () {},
                                          );
                                        } else {
                                          NavigationService.pushNamed(
                                            RouteName.videoPlayer,
                                            extra: VideoPlayerArgs(
                                              video: video,
                                              videoUrl: video.videoUrl,
                                              videoTitle: video.title,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  itemCount: state.videos.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                        return 12.verticalSpace;
                                      },
                                ),
                              );
                            },
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
