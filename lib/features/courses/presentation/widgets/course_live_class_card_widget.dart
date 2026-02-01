// ignore_for_file: unused_element

import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/thumbnail_widget.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CourseLiveClassCardWidget extends StatelessWidget {
  final LiveClassDetailModel liveClass;
  final bool isLive;
  final bool isUpcoming;
  final bool isEnded;
  final int sessionNumber;
  const CourseLiveClassCardWidget({
    super.key,
    required this.liveClass,
    this.isLive = false,
    this.isUpcoming = false,
    this.isEnded = false,
    required this.sessionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUserLocked = liveClass.isUserLocked;
    return InkWell(
      onTap: () =>
          _handleCardTap(context, liveClass, isLive, isUpcoming, isEnded),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(12.r),
          border: BoxBorder.all(
            width: isLive ? 1.5.w : 1.w,
            color: isLive ? Colors.red.shade200 : Colors.blueGrey.shade200,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThumbnailWidget(
              url: liveClass.thumbnail,
              height: 140.h,
              width: 100.w,
            ),
            6.horizontalSpace,
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      TextWidget(
                        word: 'Session $sessionNumber',
                        size: 14,
                        weight: FontWeight.w500,
                        textColor: Colors.grey,
                      ),
                      Spacer(),
                      _buildStatusBadge(
                        isLive: isLive,
                        isEnded: isEnded,
                        isUpcoming: isUpcoming,
                      ),
                    ],
                  ),
                  // 8.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: TextWidget(
                          word: liveClass.title,
                          weight: FontWeight.w900,
                          size: 16,
                          maxLines: 2,
                          textColor: isUserLocked
                              ? Colors.grey
                              : customColors.blackWhite,
                        ),
                      ),
                    ],
                  ),
                  12.verticalSpace,

                  //Date and time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16.w,
                        color: Colors.grey,
                      ),
                      6.horizontalSpace,
                      TextWidget(
                        word: _formatDate(liveClass.startTime),
                        textColor: Colors.grey,
                        size: 13,
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                      6.horizontalSpace,
                      TextWidget(
                        word: _formatTimeRange(
                          liveClass.startTime,
                          liveClass.endTime,
                        ),
                        textColor: Colors.grey,
                        size: 13,
                      ),
                    ],
                  ),

                  //Teacher (if availble)
                  if (liveClass.teacher.isNotEmpty) ...[
                    6.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        6.horizontalSpace,
                        TextWidget(
                          word: liveClass.teacher,
                          size: 13,
                          textColor: Colors.grey,
                        ),
                      ],
                    ),
                    // 12.verticalSpace,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isLive,
    bool isUpcoming,
    bool isEnded,
    LiveClassDetailModel liveClass,
  ) {
    if (isLive) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: Colors.white, size: 18.w),
            4.horizontalSpace,
            TextWidget(
              word: 'Join Now',
              textColor: Colors.white,
              size: 13,
              weight: FontWeight.w900,
            ),
          ],
        ),
      );
    } else {
      return Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: appColors.primary,
      );
    }
  }

  Widget _buildStatusBadge({
    bool isLive = false,
    bool isUpcoming = false,
    bool isEnded = false,
  }) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    if (isLive) {
      badgeColor = Colors.red;
      badgeText = 'LIVE';
      badgeIcon = Icons.circle;
    } else if (isUpcoming) {
      badgeColor = appColors.primary;
      badgeText = 'Upcoming';
      badgeIcon = Icons.schedule;
    } else {
      badgeColor = Colors.grey;
      badgeText = 'Ended';
      badgeIcon = Icons.check_circle_outline;
    }
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive)
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
            )
          else
            Icon(badgeIcon, size: 12.sp, color: badgeColor),
          4.horizontalSpace,
          TextWidget(
            word: badgeText,
            textColor: badgeColor,
            size: 11,
            weight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  void _handleCardTap(
    BuildContext context,
    LiveClassDetailModel liveClass,
    bool isLive,
    bool isUpcoming,
    bool isEnded,
  ) {
    if (liveClass.isUserLocked) {
      OverlayToastWidget.show(message: 'Please enroll to access live classes');
      return;
    }
    if (isLive) {
      //Navigate to liveClassScreen
      // NavigationService.pushNamed(
      //   RouteName.zoomWebView,
      //   extra: liveClass.meetingUrl,
      // );
      logger.d('Navigated to LiveScreen: ${liveClass.meetingUrl}');
    } else {
      //Navigate to liveDetailScreen
      // NavigationService.pushNamed(
      //   RouteName.liveclassDetail,
      //   extra: liveClass.id,
      // );
    }
  }

  //Calculating today, tomorrow or other dates
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final classDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (classDate == today) {
      return 'Today';
    } else if (classDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return DateFormat('MMM dd, yyy').format(dateTime);
    }
  }

  //yesma chai hour, minute and secs calculation
  String _formatTimeRange(DateTime start, DateTime end) {
    final startTime = DateFormat('hh: mm a').format(start);
    final endTime = DateFormat('hh: mm a').format(end);

    return '$startTime - $endTime';
  }
}
