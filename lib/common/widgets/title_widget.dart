import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      width: double.infinity,

      child: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 36.h, // set size manually
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextWidget(
                word: title,
                size: 26,
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
