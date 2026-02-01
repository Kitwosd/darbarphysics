import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: double.infinity,
      color: Theme.of(context).appBarTheme.backgroundColor,

      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 4.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_rounded,
                size: 32.h, // set size manually
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            20.horizontalSpace,
            TextWidget(
              word: title,
              size: 24,
              weight: FontWeight.w600,
              textColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
