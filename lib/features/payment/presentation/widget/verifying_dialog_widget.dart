import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyingDialogWidget extends StatelessWidget {
  const VerifyingDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      
      canPop: false, // Can't dismiss with back button
      child: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(appColors.primary),
                ),
                SizedBox(height: 20.h),
                TextWidget(
                  word: 'Verifying Payment...',
                  size: 16,
                  weight: FontWeight.bold,
                ),
                SizedBox(height: 8.h),
                TextWidget(
                  word: 'Please wait while we confirm your payment',
                  size: 12,
                  textColor: Colors.grey,
                  align: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                TextWidget(
                  word: 'This may take up to 30 seconds',
                  size: 11,
                  textColor: Colors.grey[400]!,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
