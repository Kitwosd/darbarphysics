import 'package:dubar_physics/common/widgets/text_widget.dart';
import 'package:dubar_physics/features/home/data/models/stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategories extends StatelessWidget {
  final List<StreamModel> streams;

  const HomeCategories({super.key, required this.streams});

  @override
  Widget build(BuildContext context) {
    if (streams.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: streams.length,
        separatorBuilder: (context, index) => SizedBox(width: 15.w),
        itemBuilder: (context, index) {
          final stream = streams[index];
          // Determine if selected (For now static, can be made stateful later)
          final isSelected = index == 0;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: TextWidget(
                word: stream.name,
                size: 14,
                weight: FontWeight.w600,
                textColor: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          );
        },
      ),
    );
  }
}
