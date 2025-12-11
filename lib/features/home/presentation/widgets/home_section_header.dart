import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            word: title,
            size: 18,
            weight: FontWeight.bold,
            textColor: Theme.of(context).textTheme.titleLarge?.color,
          ),
          TextButton(
            onPressed: onSeeAll,
            child: TextWidget(
              word: "See all",
              size: 14,
              textColor: Theme.of(context).primaryColor,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
