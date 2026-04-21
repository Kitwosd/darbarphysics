import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThumbnailWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final String url;
  const ThumbnailWidget({
    super.key,
    this.height,
    this.width,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: url.isNotEmpty
          ? Image.network(
              url,
              height: height ?? 140.h,

              width: width ?? 100.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Container(
                  height: height ?? 140.h,
                  width: width ?? 260.w,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.videocam_off,
                    size: 40.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          : Container(
              height: height ?? 140.h,
              width: width ?? 100.w,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam_off_outlined,
                    size: 40.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  8.verticalSpace,
                  TextWidget(
                    word: 'No preview',
                    textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
    );
  }
}
