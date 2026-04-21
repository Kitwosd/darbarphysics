import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnrollmentDialogWidget extends StatelessWidget {
  final VoidCallback? onGoToCourse;
  final VoidCallback? onCancel;
  final bool forVideo;

  const EnrollmentDialogWidget({
    super.key,
    this.onGoToCourse,
    this.onCancel,
    this.forVideo = true,
  });

  // Static method to show the dialog
  static Future<void> show(
    BuildContext context, {
    bool? forVideo,
    VoidCallback? onGoToCourse,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => EnrollmentDialogWidget(
        onGoToCourse: onGoToCourse,
        onCancel: () => Navigator.of(context).pop(),
        forVideo: forVideo ?? true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 16,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Lock Icon
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock,
                      color: Colors.blue[700],
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enrollment Required',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Premium Content',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  IconButton(
                    onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withValues(alpha: 0.5),
                    ),
                    padding: EdgeInsets.zero,
                    // constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Body Section
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Text(
                    forVideo
                        ? 'To access this video, please enroll in the course first. You\'ll unlock all premium videos and course materials.'
                        : 'To access this live class, please enroll in the course first. You\'ll unlock all premium live classes, videos and course materials.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              onCancel ?? () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Go to Course Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            onGoToCourse?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Go to Course',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
