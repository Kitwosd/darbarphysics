import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/package/data/model/package_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PackageDetailBottomBar extends StatelessWidget {
  final PackageDetailModel package;

  const PackageDetailBottomBar({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  word: "Total Price",
                  size: 12,
                  textColor: Colors.grey[600],
                ),
                TextWidget(
                  word: "Rs. ${package.price}",
                  size: 20,
                  weight: FontWeight.w900,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement enrollment logic later
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: const TextWidget(
                  word: "Unlock Package",
                  size: 16,
                  weight: FontWeight.bold,
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
