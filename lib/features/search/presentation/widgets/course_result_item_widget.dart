import 'package:durbar_physics/common/widgets/numbering_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseResultItemWidget extends StatelessWidget {
  final CourseModel course;
  final int? index;
  final double? height;
  final double? width;
  const CourseResultItemWidget({
    super.key,
    required this.course,
    this.index,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          NavigationService.pushNamed(RouteName.detailScreen, extra: course.id),
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
                  height: height ?? 75.h,
                  width: width ?? 100.w,
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
                          ),
                          16.horizontalSpace,
                          Spacer(),
                          Icon(
                            Icons.people,
                            size: 14.sp,
                            color: Theme.of(context).hintColor,
                          ),
                          4.horizontalSpace,

                          TextWidget(
                            word: (double.tryParse(course.cost) ?? 0) == 0
                                ? 'All Students'
                                : '${course.studentCount} students',
                            size: 14,
                          ),
                          10.horizontalSpace,
                        ],
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Icon(Icons.video_library, size: 14.sp),
                          4.horizontalSpace,
                          TextWidget(word: '${course.lessonCount}', size: 14),
                          8.horizontalSpace,
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: TextWidget(
                              word: (double.tryParse(course.cost) ?? 0) == 0
                                  ? 'Free'
                                  : 'NRs. ${course.cost}',
                              size: 14,
                              textColor: appColors.primary,
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
          if (index != null)
            Positioned(left: 4, top: 4, child: NumberingWidget(index: index!)),
        ],
      ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context, {
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
