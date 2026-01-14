import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
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
          return SizedBox(
            height: 180.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: state.liveClasses.length,
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              itemBuilder: (context, index) {
                final liveClass = state.liveClasses[index];
                return GestureDetector(
                  onTap: () {
                    if (liveClass.isLive) {
                      NavigationService.pushNamed(
                        RouteName.zoomWebView,
                        extra: {'url': liveClass.meetingUrl},
                      );
                    } else {
                      NavigationService.pushNamed(
                        RouteName.liveclassDetail,
                        extra: liveClass.id,
                      );
                    }
                  },
                  child: Container(
                    width: 260.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.r),
                              ),
                              child: Image.network(
                                liveClass.thumbnail,
                                height: 110.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 110.h,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.videocam_off),
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
                                    borderRadius: BorderRadius.circular(4.r),
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
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                word: liveClass.title,
                                size: 14,
                                weight: FontWeight.bold,
                                maxLines: 1,
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
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
