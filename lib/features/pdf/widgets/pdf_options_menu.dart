import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfOptionsMenu extends StatelessWidget {
  final PdfViewerController controller;

  const PdfOptionsMenu({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.zoom_in, color: theme.primaryColor),
            title: TextWidget(
              word: 'Zoom In',
              size: 15,
              textColor: theme.textTheme.bodyLarge?.color,
            ),
            onTap: () {
              controller.zoomLevel = controller.zoomLevel + 0.5;
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.zoom_out, color: theme.primaryColor),
            title: TextWidget(
              word: 'Zoom Out',
              size: 15,
              textColor: theme.textTheme.bodyLarge?.color,
            ),
            onTap: () {
              if (controller.zoomLevel > 1.0) {
                controller.zoomLevel = controller.zoomLevel - 0.5;
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.fit_screen, color: theme.primaryColor),
            title: TextWidget(
              word: 'Reset Zoom',
              size: 15,
              textColor: theme.textTheme.bodyLarge?.color,
            ),
            onTap: () {
              controller.zoomLevel = 1.0;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}