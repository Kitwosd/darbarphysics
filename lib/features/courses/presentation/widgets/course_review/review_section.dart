import 'package:durbar_physics/common/enums/enums.dart';
import 'package:durbar_physics/common/widgets/overlay_toast_widget.dart';
import 'package:durbar_physics/common/widgets/text_field_widget.dart';
import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/common/widgets/view_more_card_widget.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:durbar_physics/features/courses/data/model/course_review/review_model.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/courses/courses_bloc.dart';
import 'package:durbar_physics/features/courses/presentation/bloc/review/review_bloc.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/character_counter_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/no_reviews_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/rating_label_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/reviews_header_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/reviews_list_widget.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/star_rating_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewSection extends StatelessWidget {
  final int courseId;
  final bool isUserLocked;
  const ReviewSection({
    super.key,
    required this.courseId,
    required this.isUserLocked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ReviewBloc>()..add(GetReviewsEvent(courseId: courseId)),
      child: ReviewScreenView(courseId: courseId, isUserLocked: isUserLocked),
    );
  }
}

class ReviewScreenView extends StatelessWidget {
  final int courseId;
  final bool isUserLocked;
  const ReviewScreenView({
    super.key,
    required this.courseId,
    required this.isUserLocked,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ReviewStatus.success) {
          OverlayToastWidget.show(
            message: state.successMessage,
            bgColor: Colors.green.shade400,
          );
          context.read<ReviewBloc>().add(GetReviewsEvent(courseId: courseId));
          context.read<CoursesBloc>().add(
            GetCourseDetailEvent(courseId: courseId),
          );
        }
        if (state.status == ReviewStatus.error) {
          OverlayToastWidget.show(
            message: state.errorMessage,
            bgColor: Colors.red.shade400,
          );
        }
      },

      child: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state.reviewsListStatus == ApiDataStatus.success) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUserLocked)
                  _enrollmentRequiredBanner(context)
                else
                  _ratingInputSection(context),

                24.verticalSpace,
                // ADDED: divider before reviews list
                Divider(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  thickness: 1,
                ),
                24.verticalSpace,
                // END ADDED
                ReviewsHeaderWidget(),
                16.verticalSpace,

                BlocSelector<ReviewBloc, ReviewState, List<ReviewModel>>(
                  selector: (state) {
                    return state.reviewsList;
                  },
                  builder: (context, reviewsList) {
                    if (reviewsList.isEmpty) {
                      return NoReviewsWidget();
                    }
                    return ReviewsListWidget(reviews: reviewsList);
                  },
                ),
                10.verticalSpace,
                BlocSelector<ReviewBloc, ReviewState, bool>(
                  selector: (state) => state.hasReachedMax,
                  builder: (context, hasReachedMax) {
                    if (!hasReachedMax) {
                      return ViewMoreCardWidget(
                        onTap: () {
                          context.read<ReviewBloc>().add(
                            LoadMoreReviewsEvent(courseId: courseId),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                24.verticalSpace,
              ],
            );
          }
          if (state.reviewsListStatus == ApiDataStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.reviewsListStatus == ApiDataStatus.error) {
            return Center(child: TextWidget(word: 'Something went wrong'));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  // Banner for unenrolled users
  Widget _enrollmentRequiredBanner(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: primary.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  word: "Enroll to Leave a Review",
                  weight: FontWeight.bold,
                  size: 16,
                ),
                SizedBox(height: 6.h),
                TextWidget(
                  word:
                      "Join this course to share your experience and help others",
                  size: 13,
                  textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingInputSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          word: 'Share Your Experience',
          size: 18,
          weight: FontWeight.w900,
        ),
        4.verticalSpace,
        TextWidget(
          word: 'Help others learn from your experience with this course',
          size: 13.sp,
          textColor: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        16.verticalSpace, // ADDED: spacing between subtitle and star rating card
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: isDark
                ? Border.all(color: Colors.grey[800]!, width: 1)
                : null,
          ),
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocSelector<ReviewBloc, ReviewState, double>(
                selector: (state) {
                  return state.selectedRating;
                },
                builder: (context, selectedRating) {
                  return StarRatingInputWidget(
                    selectedRating: selectedRating,
                    onRatingSelected: (rating) {
                      context.read<ReviewBloc>().add(
                        RatingSelectedEvent(rating: rating),
                      );
                    },
                  );
                },
              ),
              10.verticalSpace,

              BlocSelector<ReviewBloc, ReviewState, double>(
                selector: (state) {
                  return state.selectedRating;
                },
                builder: (context, rating) {
                  return RatingLabel(rating: rating);
                },
              ),
            ],
          ),
        ),

        10.verticalSpace,
        TextFieldWidget(
          hintText:
              'Tell us what you think about this course, What did you like? What could be improved?',
          label: '', // CHANGED: was 'Hello' — fixed placeholder label
          borderRadius: 16.r,
          maxLines: 4,
          verticalPadding: 12.h,
          onChanged: (value) {
            context.read<ReviewBloc>().add(ReviewTextChangedEvent(text: value));
          },
        ),
        12.verticalSpace,
        BlocSelector<ReviewBloc, ReviewState, Map<String, dynamic>>(
          selector: (state) {
            return {
              'characterCount': state.characterCount,
              'isMinCharacterMet': state.isMinCharacterMet,
            };
          },
          builder: (context, state) {
            return CharacterCounterWidget(
              characterCount: state['characterCount'] as int,
              isMinCharacterMet: state['isMinCharacterMet'] as bool,
            );
          },
        ),
        10.verticalSpace,
        BlocSelector<ReviewBloc, ReviewState, bool>(
          selector: (state) {
            return state.isSubmitEnabled;
          },
          builder: (context, isSubmitEnabled) {
            // CHANGED: removed Row + '*Button Disabled*' debug text, kept just the button
            return Center(
              child: ElevatedButton(
                onPressed: isSubmitEnabled
                    ? () {
                        context.read<ReviewBloc>().add(
                          PostReviewEvent(courseId: courseId),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      word: 'Submit Review',
                      size: 16,
                      weight: FontWeight.w600,
                      textColor: isSubmitEnabled
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            );
            // COMMENTED OUT: debug text that was here
            // 20.horizontalSpace,
            // TextWidget(
            //   word: isSubmitEnabled ? '' : '*Button Disabled*',
            //   weight: FontWeight.w500,
            //   size: 16,
            //   textColor: isSubmitEnabled ? Colors.green : Colors.red,
            // ),
          },
        ),
      ],
    );
  }
}
