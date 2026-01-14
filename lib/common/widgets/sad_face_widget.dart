import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SadFaceWidget extends StatelessWidget {
  const SadFaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          //Robot Body
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFF4FACFE),
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: appColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Stack(
              children: [
                //left eye
                Positioned(
                  left: 15.w,
                  top: 20.h,
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                //right eye
                Positioned(
                  right: 15.w,
                  top: 20.h,
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                //Sad Mouth
                Positioned(
                  child: Center(
                    child: Transform.rotate(
                      angle: 3.14159, //180 degrees,
                      child: CustomPaint(
                        size: Size(30.w, 15.h),
                        painter: SadMouthPainter(),
                      ),
                    ),
                  ),
                ),

                //Antenna
                Positioned(
                  top: 0,
                  child: Column(
                    children: [
                      Container(
                        width: 3.w,
                        height: 15.h,
                        color: appColors.primary,
                      ),
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: appColors.primary,
                          shape: BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              color: appColors.primary.withValues(alpha: 0.5),
                              blurRadius: 8.r,
                              spreadRadius: 2.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SadMouthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
