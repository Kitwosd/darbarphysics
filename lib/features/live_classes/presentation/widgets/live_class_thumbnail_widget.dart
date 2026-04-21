import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveClassThumbnailWidget extends StatelessWidget {
  final LiveClassModel liveClass;
  final String? index;
  const LiveClassThumbnailWidget({
    super.key,
    required this.liveClass,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 75.h,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade400, Colors.pink.shade400],
            ),
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8.r),
            child: liveClass.thumbnail.isNotEmpty
                ? Image.network(
                    liveClass.thumbnail,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
        ),
        if (liveClass.isLive)
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  TextWidget(
                    word: 'LIVE',
                    size: 9,
                    textColor: Colors.white,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(Icons.videocam, size: 32.sp, color: Colors.white),
    );
  }
}
