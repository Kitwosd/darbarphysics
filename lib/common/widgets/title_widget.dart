import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? function;

  const TitleWidget({super.key, required this.title, this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,

      child: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (function != null) {
                  function!();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Column(
                children: [
                  2.verticalSpace,
                  Icon(
                    Icons.keyboard_backspace_outlined,
                    size: 36.sp, // set size manually
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            30.horizontalSpace,
            Expanded(
              child: TextWidget(
                word: title,
                size: 24,
                weight: FontWeight.w600,
                textColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
