import 'package:durbar_physics/common/widgets/numbering_widget.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/scroll_bar_wrapper_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:durbar_physics/features/home/presentation/bloc/bookmark/courses_book_bloc/course_bookmark_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SavedCoursesListWidget extends StatefulWidget {
  final List<CourseModel> courses;
  const SavedCoursesListWidget({super.key, required this.courses});

  @override
  State<SavedCoursesListWidget> createState() => _SavedCoursesListWidgetState();
}

class _SavedCoursesListWidgetState extends State<SavedCoursesListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ScrollBarWrapperWidget(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(20.w),
        itemCount: widget.courses.length,
        itemBuilder: (context, index) {
          final course = widget.courses[index];
          return Slidable(
            key: ValueKey(course.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    context.read<CourseBookmarkBloc>().add(
                      RemoveCourseEvent(courseId: course.id),
                    );
                    OverlayToastWidget.show(
                      message: 'Course removed from bookmarks',
                    );
                  },
                  backgroundColor: Colors.red.shade600,
                  icon: Icons.delete,
                  label: 'Remove',
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(12.r),
                  ),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => NavigationService.pushNamed(
                RouteName.detailScreen,
                extra: course.id,
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),

                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.grey,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildThumbnail(
                          context,
                          height: 75.h,
                          width: 100.w,
                          course: course,
                        ),
                        16.horizontalSpace,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              TextWidget(
                                word: course.title,
                                maxLines: 3,
                                size: 16,
                                weight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              4.verticalSpace,

                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.video_library, size: 14.sp),
                                      4.horizontalSpace,
                                      TextWidget(
                                        word: '${course.lessonCount} lessons',
                                        size: 13,
                                        weight: FontWeight.w500,
                                        textColor: Theme.of(context).hintColor,
                                      ),
                                    ],
                                  ),

                                  if (course.levelName != null)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.school_rounded,
                                            size: 15.sp,
                                            color: const Color(0xFF6366F1),
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: TextWidget(
                                              word: course.levelName!,
                                              size: 12,
                                              weight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textColor: Theme.of(
                                                context,
                                              ).hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  10.horizontalSpace,
                                ],
                              ),
                              4.verticalSpace,
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.h,
                                      horizontal: 8.w,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade100,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber.shade600,
                                          size: 14.sp,
                                        ),
                                        4.horizontalSpace,
                                        TextWidget(
                                          word: '${course.rating}',
                                          size: 12,
                                          weight: FontWeight.w600,
                                          textColor: isDark
                                              ? Colors.black.withValues(
                                                  alpha: 0.8,
                                                )
                                              : Theme.of(context).hintColor,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (course.subjectName != null)
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.menu_book_rounded,
                                            size: 15.sp,
                                            color: const Color(0xFF10B981),
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: TextWidget(
                                              word: course.subjectName!,

                                              size: 12,
                                              weight: FontWeight.w600,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textColor: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  10.horizontalSpace,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 4,
                    top: 4,
                    child: NumberingWidget(index: index),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8.h);
        },
      ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context, {
    required CourseModel course,
    required double height,
    required double width,
  }) {
    String imagePath = course.image;
    if (!imagePath.startsWith('http')) {
      imagePath = '${dotenv.env['BASE_THUMBNAIL_URL']}$imagePath';
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.blue.shade200, Colors.blue.shade600],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: course.image.isNotEmpty
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, ___) {
                  return Center(
                    child: Icon(Icons.school, size: 32.sp, color: Colors.white),
                  );
                },
              )
            : Center(
                child: Icon(Icons.school, size: 32.sp, color: Colors.white),
              ),
      ),
    );
  }
}
