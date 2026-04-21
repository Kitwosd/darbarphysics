import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfControlButtons extends StatelessWidget {
  final PdfViewerController controller;
  final VoidCallback onJumpToPage;

  const PdfControlButtons({
    super.key,
    required this.controller,
    required this.onJumpToPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Jump to Page FAB
        FloatingActionButton.small(
          heroTag: 'jump',
          backgroundColor: theme.primaryColor,
          onPressed: onJumpToPage,
          tooltip: 'Jump to page',
          child: Icon(Icons.numbers, color: Colors.white, size: 20.sp),
        ),
        SizedBox(height: 12.h),

        // Zoom In FAB
        FloatingActionButton.small(
          heroTag: 'zoomIn',
          backgroundColor: theme.primaryColor,
          onPressed: () {
            controller.zoomLevel = controller.zoomLevel + 0.25;
          },
          tooltip: 'Zoom in',
          child: Icon(Icons.add, color: Colors.white, size: 20.sp),
        ),
        SizedBox(height: 8.h),

        // Zoom Out FAB
        FloatingActionButton.small(
          heroTag: 'zoomOut',
          backgroundColor: theme.primaryColor,
          onPressed: () {
            if (controller.zoomLevel > 1.0) {
              controller.zoomLevel = controller.zoomLevel - 0.25;
            }
          },
          tooltip: 'Zoom out',
          child: Icon(Icons.remove, color: Colors.white, size: 20.sp),
        ),
      ],
    );
  }
}
