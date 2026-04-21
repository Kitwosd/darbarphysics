import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentStatusDialogWidget extends StatelessWidget {
  final bool isSuccess;
  final String message;
  final String? details;
  final VoidCallback? onContinue;

  const PaymentStatusDialogWidget({
    super.key,
    required this.isSuccess,
    required this.message,
    this.details,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogTheme.backgroundColor, 
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon with circle background ── DialogThemeData.backgroundColor
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: isSuccess
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isSuccess ? Colors.green : Colors.red,
                size: 48.w,
              ),
            ),
            20.verticalSpace,

            // ── Title ──
            TextWidget(
              word: isSuccess ? 'Payment Successful' : 'Payment Failed',
              size: 20,
              weight: FontWeight.bold,
              align: TextAlign.center,
            ),
            12.verticalSpace,

            // ── Message ──
            TextWidget(
              word: message,
              size: 14,
              textColor: customColors.greyWhite,
              align: TextAlign.center,
              overflow: TextOverflow.visible,
            ),

            // ── Details (optional) ──
            if (details != null && details!.isNotEmpty) ...[
              12.verticalSpace,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: customColors.greyWhite.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextWidget(
                  word: details!,
                  size: 12,
                  textColor: customColors.greyWhite,
                  overflow: TextOverflow.visible,
                  align: TextAlign.center,
                ),
              ),
            ],
            28.verticalSpace,

            // ── Continue Button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onContinue?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? Colors.green : appColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: TextWidget(
                  word: isSuccess ? 'Start Learning 🎉' : 'Try Again',
                  size: 16,
                  textColor: Colors.white,
                  weight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required bool isSuccess,
    required String message,
    String? details,
    VoidCallback? onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentStatusDialogWidget(
        isSuccess: isSuccess,
        message: message,
        details: details,
        onContinue: onContinue,
      ),
    );
  }
}
