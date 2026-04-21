import 'package:durbar_physics/common/widgets/user_avatar_widget.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;
  const ReviewCardWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
            border: isDark
                ? Border.all(color: Colors.grey[800]!, width: 1)
                : null,
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Container(
                  //   width: 40.w,
                  //   height: 40.w,
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //       colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  //     ),
                  //     shape: BoxShape.circle,
                  //     border: Border.all(
                  //       color: Theme.of(context).cardColor,
                  //       width: 2,
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withValues(alpha: 0.1),
                  //         blurRadius: 8,
                  //         offset: const Offset(0, 2),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Center(
                  //     child: Text(
                  //       review.name[0],
                  //       style: TextStyle(
                  //         fontSize: 16.sp,
                  //         fontWeight: FontWeight.w700,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  UserAvatarWidget(
                    name: review.name,
                    imageUrl:
                        '${dotenv.env['BASE_THUMBNAIL_URL']}${review.picture}',
                    radius: 20.r,
                    fontSize: 14.sp,
                  ),

                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFFA500),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '★',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    review.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              ' ${DateFormat('dd MMM yyyy').format(review.createdAt)}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark
                                    ? Colors.grey[500]
                                    : const Color(0xFF999999),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                review.review ?? '',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        // Golden corner accent - TOP LEFT
        Positioned(
          top: 0,
          left: 0,
          child: CustomPaint(
            size: Size(40.w, 40.w),
            painter: _TopLeftCornerPainter(),
          ),
        ),
      ],
    );
  }
}

class _TopLeftCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.5, 0);

    canvas.drawPath(path, paint);

    // Triangle fill with opacity
    final fillPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final fillPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
