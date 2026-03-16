import 'package:durbar_physics/common/widgets/enrollment_dialog_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveClassActionButtonWidget extends StatelessWidget {
  final LiveClassDetailModel liveClass;

  const LiveClassActionButtonWidget({super.key, required this.liveClass});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    if (liveClass.status == 'live') {
      return _buildJoinLiveButton(context);
    } else if (liveClass.status == 'ended' && liveClass.isRecorded) {
      return _buildViewRecordingButton(context);
    } else if (liveClass.willStartSoon) {
      return _buildStartingSoonButton(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildJoinLiveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (liveClass.isUserLocked) {
          EnrollmentDialogWidget.show(
            context,
            onGoToCourse: () => {
              NavigationService.pushNamed(
                RouteName.detailScreen,
                extra: liveClass.course,
              ),
            },
          );
          return;
        }
        NavigationService.pushNamed(
          RouteName.zoomWebView,
          extra: {'url': liveClass.meetingUrl},
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam, size: 20.sp),
          SizedBox(width: 8.w),
          TextWidget(
            word: 'Join Live Class',
            size: 16,
            weight: FontWeight.bold,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildViewRecordingButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (liveClass.recordingUrl != null) {
          NavigationService.pushNamed(
            RouteName.zoomWebView,
            extra: {'url': liveClass.recordingUrl},
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_circle_filled, size: 20.sp),
          SizedBox(width: 8.w),
          TextWidget(
            word: 'View Recording',
            size: 16,
            weight: FontWeight.bold,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStartingSoonButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade300, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 20.sp, color: Colors.orange.shade700),
          SizedBox(width: 8.w),
          TextWidget(
            word: 'Class Starting Soon',
            size: 16,
            weight: FontWeight.bold,
            textColor: Colors.orange.shade700,
          ),
        ],
      ),
    );
  }
}
