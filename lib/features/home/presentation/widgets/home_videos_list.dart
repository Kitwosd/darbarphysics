import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/enrollment_dialog_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/view_more_card_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/presentation/screens/youtube_video_player_screen.dart';
import 'package:durbar_physics/features/home/presentation/bloc/videos/videos_bloc.dart';
import 'package:durbar_physics/features/home/presentation/widgets/video_thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeVideosList extends StatelessWidget {
  const HomeVideosList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosBloc, VideosState>(
      builder: (BuildContext context, VideosState state) {
        if (state.status == ApiDataStatus.loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.status == ApiDataStatus.success) {
          return Builder(
            builder: (context) {
              return SizedBox(
                height: 190.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: state.videos.length + 1,
                  separatorBuilder: (context, index) => SizedBox(width: 15.w),
                  itemBuilder: (context, index) {
                    if (index == state.videos.length) {
                      if (state.hasReachedMax) {
                        return SizedBox.shrink();
                      }
                      return ViewMoreCardWidget(
                        onTap: () {
                          context.read<VideosBloc>().add(LoadMoreVideosEvent());
                        },
                      );
                    }
                    final video = state.videos[index];
                    bool isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    bool canAccess = !(video.isLocked && video.isUserLocked);

                    return InkWell(
                      child: Container(
                        width: 250.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).shadowColor.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VideoThumbnailWidget(
                              video: video,
                              isDark: isDark,
                              width: 250,
                              height: 100,
                            ),

                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      word: video.title,
                                      size: 14,
                                      weight: FontWeight.bold,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (!canAccess) {
                          EnrollmentDialogWidget.show(
                            context,
                            onGoToCourse: () {
                              if (video.course != null) {
                                NavigationService.pushNamed(
                                  RouteName.detailScreen,
                                  extra: video.course,
                                );
                              }
                            },
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  YoutubeVideoPlayerScreen(video: video),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              );
            },
          );
        } else if (state.status == ApiDataStatus.error) {
          return SizedBox.shrink();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
