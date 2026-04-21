import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/error_screen.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/document_model.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/document/document_cubit.dart';
import 'package:durbar_physics/features/pdf/screens/pdf_viewer_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentListScreen extends StatelessWidget {
  final int courseId;
  const DocumentListScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<DocumentCubit>();
        cubit.getCourseDocuments(courseId: courseId);
        return cubit;
      },
      child: DocumentList(courseId: courseId),
    );
  }
}

class DocumentList extends StatelessWidget {
  final int courseId;
  const DocumentList({super.key, required this.courseId});

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
      body: BlocBuilder<DocumentCubit, DocumentState>(
        builder: (context, state) {
          if (state.status == ApiDataStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.status == ApiDataStatus.error) {
            return ErrorScreen(
              homeButtonText: 'Return Back',
              onGoHome: () => Navigator.pop(context),
              onRetry: () => context.read<DocumentCubit>().getCourseDocuments(
                courseId: courseId,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(20.w),
            itemCount: state.documents.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final document = state.documents[index];
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
          );
        },
      ),
    );
  }
}
