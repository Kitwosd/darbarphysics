import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/services/pagination_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/view_more_card_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';

import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/live_classes/presentation/bloc/live_classes_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeLiveClassesList extends StatelessWidget {
  const HomeLiveClassesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveClassesBloc, LiveClassesState>(
      builder: (context, state) {
        if (state.status == ApiDataStatus.loading) {
          return SizedBox(
            height: 80.h,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state.status == ApiDataStatus.error) {
          return SizedBox(
            height: 80,
            child: TextWidget(word: 'Something Went Wrong'),
          );
        } else if (state.status == ApiDataStatus.success) {
          if (state.liveClasses.isEmpty) {
            return const SizedBox.shrink();
          }

          return PaginationWrapperWidget(
            hasReachedMax: state.hasReachedMax,
            onLoadMore: () {
              context.read<LiveClassesBloc>().add(LoadMoreLiveClassEvent());
            },
            builder: (ScrollController controller) {
              return Scrollbar(
                interactive: true,
                radius: Radius.circular(6.r),
                thickness: 8.w,
                controller: controller,
                child: SizedBox(
                  height: 240.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.liveClasses.length + 1,
                    separatorBuilder: (context, index) => SizedBox(width: 15.w),
                    itemBuilder: (context, index) {
                      if (index == state.liveClasses.length) {
                        if (state.hasReachedMax == true) {
                          return SizedBox.shrink();
                        }
                        return ViewMoreCardWidget(
                          onTap: () {
                            context.read<LiveClassesBloc>().add(
                              LoadMoreLiveClassEvent(),
                            );
                          },
                        );
                      }
                      final liveClass = state.liveClasses[index];
                      return GestureDetector(
                        onTap: () {
                          //TODO: LiveClass enrollment dialog
                          // if (liveClass.isLive) {
                          //   if (liveClass.isUserLocked) {
                          //     NavigationService.pushNamed(
                          //       RouteName.zoomWebView,
                          //       extra: {'url': liveClass.meetingUrl},
                          //     );
                          //   } else {
                          // EnrollmentDialogWidget.show(
                          //   context,
                          //   forVideo: false,

                          //   onGoToCourse: () => NavigationService.pushNamed(
                          //     RouteName.detailScreen,
                          //     extra: liveClass.course,
                          //   ),
                          // );
                          // }
                          // } else {
                          NavigationService.pushNamed(
                            RouteName.liveclassDetail,
                            extra: liveClass.id,
                          );
                          // }
                        },
                        child: Container(
                          width: 260.w,

                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).shadowColor.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12.r),
                                    ),
                                    child: liveClass.thumbnail.isNotEmpty
                                        ? Image.network(
                                            'https://fastly.picsum.photos/id/33/536/354.jpg?hmac=dr3g8fDBO7YqDieYQlNLa3FzuRJnuthiLi-JKQrwtQk',
                                            height: 140.h,

                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Center(
                                                  child: Container(
                                                    height: 140.h,
                                                    width: 260.w,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                    child: Icon(
                                                      Icons.videocam_off,
                                                      size: 60.sp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant,
                                                    ),
                                                  ),
                                                ),
                                          )
                                        : Container(
                                            height: 140.h,
                                            width: double.infinity,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHighest,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.videocam_off_outlined,
                                                  size: 40.sp,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                                8.verticalSpace,
                                                TextWidget(
                                                  word: 'No preview',
                                                  textColor: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  if (liveClass.isLive)
                                    Positioned(
                                      top: 8.h,
                                      left: 8.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 8.sp,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4.w),
                                            TextWidget(
                                              word: "LIVE",
                                              size: 10,
                                              textColor: Colors.white,
                                              weight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    10.verticalSpace,
                                    TextWidget(
                                      word: liveClass.title,
                                      size: 14,
                                      weight: FontWeight.bold,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          word: liveClass.teacherName,
                                          size: 12,
                                          textColor: appColors.secondary,
                                        ),
                                        if (liveClass.status != 'live')
                                          TextWidget(
                                            word: DateFormat(
                                              'MMM d, h:mm a',
                                            ).format(liveClass.startTime),
                                            size: 10,
                                            textColor: Colors.grey,
                                            weight: FontWeight.w500,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
