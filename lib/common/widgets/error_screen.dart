import 'package:durbar_physics/common/widgets/sad_face_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorScreen extends StatefulWidget {
  final String? errorMessage;
  final String? errorTitle;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;
  final String? retryButtonText;
  final String? homeButtonText;
  const ErrorScreen({
    super.key,
    this.errorMessage,
    this.errorTitle,
    this.onRetry,
    this.onGoHome,
    this.retryButtonText,
    this.homeButtonText,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _shakeAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColors.whiteBlack,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                180.verticalSpace,
                //Broken Robot Showing
                _buildBrokenRobot(),
                40.verticalSpace,

                //Error Title
                TextWidget(
                  word: widget.errorTitle ?? 'Oops!',
                  size: 32,
                  weight: FontWeight.w700,
                  textColor: const Color(0xFF333333),
                ),
                16.verticalSpace,

                //Error message
                TextWidget(
                  word:
                      widget.errorMessage ??
                      'Something went wrong. \nOur robot are working on it!',
                  align: TextAlign.center,
                  size: 16,
                  textColor: const Color(0xFF666666),
                ),
                40.verticalSpace,

                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrokenRobot() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _shakeAnimation.value,
          child: SadFaceWidget(),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.center,
      children: [
        // Retry Button
        if (widget.onRetry != null)
          ElevatedButton(
            onPressed: widget.onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FACFE),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: Color(0xFF4FACFE).withValues(alpha: 0.3),
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              widget.retryButtonText ?? 'Try Again',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),

        // Go Home Button
        if (widget.onGoHome != null)
          OutlinedButton(
            onPressed: widget.onGoHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4FACFE),
              side: BorderSide(color: const Color(0xFF4FACFE), width: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              widget.homeButtonText ?? 'Go Home',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}
