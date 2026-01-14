import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionCardWidget extends StatelessWidget {
  final LiveClassDetailModel liveClass;

  const DescriptionCardWidget({super.key, required this.liveClass});

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
                Icons.description,
                size: 20.sp,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 8.w),
              TextWidget(
                word: 'Description',
                size: 16,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextWidget(
            word: liveClass.description,
            size: 14,
            textColor: Theme.of(context).hintColor,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
