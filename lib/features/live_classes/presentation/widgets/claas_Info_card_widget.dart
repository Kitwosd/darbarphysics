import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassInfoCardWidget extends StatelessWidget {
  final LiveClassDetailModel liveClass;

  const ClassInfoCardWidget({super.key, required this.liveClass});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 8.w),
              TextWidget(
                word: 'Class Information',
                size: 16,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            context,
            Icons.subject,
            'Subject',
            'Subject ID: ${liveClass.subject}',
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            context,
            Icons.signal_cellular_alt,
            'Level',
            'Level ${liveClass.level}',
          ),
          if (liveClass.course != null) ...[
            SizedBox(height: 12.h),
            _buildCourseRow(context),
          ],
          if (liveClass.isRecorded) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              context,
              Icons.video_library,
              'Recording',
              'Available',
              iconColor: Colors.green,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: (iconColor ?? Theme.of(context).primaryColor).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 18.sp,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                word: label,
                size: 12,
                textColor: Theme.of(context).hintColor,
              ),
              SizedBox(height: 2.h),
              TextWidget(word: value, size: 14, weight: FontWeight.w600),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseRow(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to course detail page
        NavigationService.pushNamed(
          RouteName.detailScreen,
          extra: liveClass.course ?? 9,
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.blue.shade200, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.book, size: 18.sp, color: Colors.blue.shade700),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    word: 'Related Course',
                    size: 12,
                    textColor: Colors.blue.shade700,
                  ),
                  SizedBox(height: 2.h),
                  TextWidget(
                    word: 'View Course Details',
                    size: 14,
                    weight: FontWeight.w600,
                    textColor: Colors.blue.shade900,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Colors.blue.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
