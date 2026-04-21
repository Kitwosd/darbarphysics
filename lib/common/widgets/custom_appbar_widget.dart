import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool centerTitle;
  const CustomAppbarWidget({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextWidget(
        word: title,
        size: 20,
        weight: FontWeight.w600,
        textColor: appColors.primary,
      ),
      centerTitle: centerTitle,
      leading: showBackButton
          ? Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_backspace_outlined,
                  color: appColors.primary,
                  size: 36.sp,
                ),
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
