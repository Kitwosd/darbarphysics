import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/document_model.dart';
import 'package:durbar_physics/features/pdf/screens/pdf_viewer_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentsListScreen extends StatelessWidget {
  const DocumentsListScreen({super.key});

  // Static data for demonstration
  static final List<DocumentModel> _demoDocuments = [
    DocumentModel(
      id: '1',
      title: 'Introduction to Physics',
      url:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    DocumentModel(
      id: '2',
      title: 'Chapter 1: Mechanics',
      url:
          'https://mail.dpnet.org.np/public/uploads/files/Nepal_Disaster_Report_Final_2024_1%202025-05-11%2010-30-50.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 7)),
    ),
    DocumentModel(
      id: '3',
      title: 'Problem Set - Week 1',
      url:
          'https://api.slingacademy.com/v1/sample-data/files/text-and-table.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
    ),
    DocumentModel(
      id: '4',
      title: 'Reference Materials',
      url: 'https://example.com/reference.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 30)),
    ),
    DocumentModel(
      id: '5',
      title: 'Thermodynamics Notes',
      url: 'https://example.com/thermodynamics.pdf',
      createdAt: DateTime.now().subtract(Duration(hours: 5)),
    ),
    DocumentModel(
      id: '6',
      title: 'Quantum Physics Lecture',
      url: 'https://example.com/quantum.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 14)),
    ),
    DocumentModel(
      id: '7',
      title: 'Electromagnetism Study Guide',
      url: 'https://example.com/electromagnetism.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 21)),
    ),
    DocumentModel(
      id: '8',
      title: 'Laboratory Manual',
      url: 'https://example.com/lab-manual.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    DocumentModel(
      id: '9',
      title: 'Final Exam Practice Questions',
      url: 'https://example.com/exam-practice.pdf',
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
    ),
    DocumentModel(
      id: '10',
      title: 'Optics and Wave Theory',
      url: 'https://example.com/optics.pdf',
      createdAt: DateTime.now().subtract(Duration(days: 45)),
    ),
  ];

  // Color rotation for badges
  static final List<Color> _badgeColors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Orange
    Color(0xFFEC4899), // Pink
  ];

  Color _getBadgeColor(int index) {
    return _badgeColors[index % _badgeColors.length];
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _openDocument(BuildContext context, DocumentModel document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          pdfUrl: document.url,
          documentTitle: document.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: customColors.blackWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          word: 'Course Documents',
          size: 18,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20.w),
        itemCount: _demoDocuments.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final document = _demoDocuments[index];
          final badgeColor = _getBadgeColor(index);

          return GestureDetector(
            onTap: () => _openDocument(context, document),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Colored Number Badge
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: badgeColor.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: TextWidget(
                        word: '${index + 1}',
                        textColor: Colors.white,
                        size: 14,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Document Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          word: document.title,
                          size: 15,
                          weight: FontWeight.w600,
                          textColor: theme.textTheme.bodyLarge?.color,
                        ),
                        SizedBox(height: 4.h),
                        TextWidget(
                          word: 'Added ${_getTimeAgo(document.createdAt)}',
                          size: 12,
                          textColor: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.sp,
                    color: theme.iconTheme.color?.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
