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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              10.verticalSpace,

              TextWidget(
                word: isSuccess ? 'Payment Successful' : 'Payment Failed',
                size: 20,
                weight: FontWeight.bold,
              ),
              10.verticalSpace,

              TextWidget(
                word: message,
                size: 14,
                textColor: customColors.greyWhite,
                align: TextAlign.center,
              ),

              if (details != null) ...[
                10.verticalSpace,
                TextWidget(
                  word: details!,
                  size: 12,
                  textColor: customColors.greyWhite,
                  overflow: TextOverflow.visible,
                ),
              ],
              25.verticalSpace,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onContinue?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: TextWidget(
                    word: 'Continue',
                    size: 16,
                    textColor: customColors.whiteBlack,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
      barrierDismissible: true,
      builder: (context) => PaymentStatusDialogWidget(
        isSuccess: isSuccess,
        message: message,
        details: details,
        onContinue: onContinue,
      ),
    );
  }
}
