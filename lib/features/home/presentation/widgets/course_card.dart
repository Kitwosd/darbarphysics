import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/routing/route_name.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final bool isFree = (double.tryParse(course.cost) ?? 0) == 0;
    final double price = double.tryParse(course.cost) ?? 0;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _accentColor(course.levelName);

    return GestureDetector(
      onTap: () {
        NavigationService.pushNamed(RouteName.detailScreen, extra: course.id);
      },
      child: Container(
        width: 240.w,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail with gradient overlay ──
            SizedBox(
              height: 145.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  course.image != null
                      ? Image.network(
                          course.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildPlaceholder(colorScheme),
                        )
                      : _buildPlaceholder(colorScheme),

                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.52),
                        ],
                        stops: const [0.45, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body: accent bar + content ──
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left accent bar
                  Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18.r),
                      ),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 11.h, 12.w, 13.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grade label
                          if (course.levelName != null)
                            Text(
                              course.levelName!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                                letterSpacing: 0.5,
                              ),
                            )
                          else
                            Text(
                              'Unknown',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.5),
                              ),
                            ),

                          SizedBox(height: 6.h),

                          // Title — fixed 2-line height, bottom aligned
                          SizedBox(
                            height: 44.h,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                course.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodyLarge?.color,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 11.h),

                          // Bottom row: rating + price/free pill
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 15.sp,
                                color: Colors.amber,
                              ),
                              4.horizontalSpace,
                              Text(
                                '${course.rating}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const Spacer(),

                              // Free / Paid pill with arrow
                              _buildPricePill(isFree, price),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricePill(bool isFree, double price) {
    final Color bgColor = isFree
        ? const Color(0xFFECFDF5)
        : const Color(0xFFFFF7ED);
    final Color textColor = isFree
        ? const Color(0xFF065F46)
        : const Color(0xFF9A3412);
    final Color borderColor = isFree
        ? const Color(0xFF86EFAC)
        : const Color(0xFFFDBA74);
    final String label = isFree ? '✓ Free' : 'Rs. ${price.toStringAsFixed(0)}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          5.horizontalSpace,
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
            child: Center(
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 10.sp,
                fontWeight: FontWeight.w900,
                color: bgColor,
              ),

              // child: Text(
              //   '→',
              //   style: TextStyle(
              //     fontSize: 9.sp,
              //     fontWeight: FontWeight.w900,
              //     color: bgColor,
              //     height: 1,
              //   ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.primary.withValues(alpha: 0.08),
      child: Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          size: 40,
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Color _accentColor(String? levelName) {
    if (levelName == null) return const Color(0xFF9CA3AF);
    final name = levelName.toLowerCase();
    if (name.contains('10') || name.contains('see'))
      return const Color(0xFF6366F1);
    if (name.contains('11')) return const Color(0xFFDB2777);
    if (name.contains('12')) return const Color(0xFF059669);
    if (name.contains('bachelor')) return const Color(0xFF0EA5E9);
    return const Color(0xFF6366F1);
  }
}
