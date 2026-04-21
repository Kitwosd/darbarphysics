import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LockedIconWidget extends StatelessWidget {
  final bool isUserLocked;

  const LockedIconWidget({super.key, required this.isUserLocked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isUserLocked ? Colors.orange[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextWidget(
        word: isUserLocked ? 'LOCKED' : 'UNLOCKED',
        weight: FontWeight.bold,
        size: 10,
        textColor: isUserLocked ? Colors.orange[900] : Colors.green[900],
      ),
    );
  }
}
