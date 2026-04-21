import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/services/pagination_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/view_more_card_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';

import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/live_classes/presentation/bloc/live_classes_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              return SizedBox(
                height: 235.h,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  clipBehavior: Clip.none,
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
                        NavigationService.pushNamed(
                          RouteName.liveclassDetail,
                          extra: liveClass.id,
                        );
                        // }
                      },
                      child: Container(
                        width: 260.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
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
                            // Thumbnail Section
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.r),
                                  ),
                                  child: liveClass.thumbnail.isNotEmpty
                                      ? Image.network(
                                          liveClass.thumbnail,
                                          height: 140.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Container(
                                                height: 140.h,
                                                width: 260.w,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerHighest,
                                                child: Icon(
                                                  Icons.videocam_off,
                                                  size: 48.sp,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant
                                                      .withValues(alpha: 0.3),
                                                ),
                                              ),
                                        )
                                      : Container(
                                          height: 140.h,
                                          width: double.infinity,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainerHighest,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.videocam_off_outlined,
                                                size: 40.sp,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withValues(alpha: 0.4),
                                              ),
                                              6.verticalSpace,
                                              TextWidget(
                                                word: 'No preview',
                                                size: 11,
                                                textColor: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withValues(alpha: 0.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                if (liveClass.isLive)
                                  Positioned(
                                    top: 10.h,
                                    left: 10.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF3B30),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFFF3B30,
                                            ).withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 6.w,
                                            height: 6.h,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          TextWidget(
                                            word: "LIVE",
                                            size: 11,
                                            textColor: Colors.white,
                                            weight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // Content Section
                            Padding(
                              padding: EdgeInsets.only(
                                left: 14.w,
                                top: 16.h,
                                bottom: 16.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  SizedBox(
                                    // width: 180.w,
                                    child: TextWidget(
                                      word: liveClass.title,
                                      size: 15,
                                      weight: FontWeight.w600,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      height: 1.3,
                                    ),
                                  ),

                                  12.verticalSpace,

                                  // Level & Subject Row
                                  if (liveClass.levelName != null ||
                                      liveClass.subjectName != null)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 8.h),
                                      child: Row(
                                        children: [
                                          // Level
                                          if (liveClass.levelName != null) ...[
                                            Icon(
                                              Icons.school_rounded,
                                              size: 15.sp,
                                              color: const Color(0xFF6366F1),
                                            ),
                                            SizedBox(width: 5.w),
                                            Flexible(
                                              child: TextWidget(
                                                word: liveClass.levelName!,
                                                size: 12,
                                                weight: FontWeight.w600,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                          Spacer(),

                                          // Subject
                                          if (liveClass.subjectName !=
                                              null) ...[
                                            Icon(
                                              Icons.menu_book_rounded,
                                              size: 15.sp,
                                              color: const Color(0xFF10B981),
                                            ),
                                            SizedBox(width: 5.w),
                                            Flexible(
                                              child: TextWidget(
                                                word: liveClass.subjectName!,
                                                size: 12,
                                                textColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,

                                                weight: FontWeight.w600,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
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
