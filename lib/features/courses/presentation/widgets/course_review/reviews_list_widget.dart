import 'package:durbar_physics/features/courses/data/model/course_review/review_model.dart';
import 'package:durbar_physics/features/courses/presentation/widgets/course_review/review_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsListWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  const ReviewsListWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...reviews.map((review) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ReviewCardWidget(review: review),
          );
        }),
      ],
    );
  }
}
