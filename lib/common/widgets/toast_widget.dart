import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/services/app_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ToastPosition { top, bottom }

class ToastWidget {
  static void show({
    required String text,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
    ToastPosition position = ToastPosition.bottom,
    double radius = 12,
    double elevation = 6,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double maxWidth = 500,
    bool dismissOnTap = true,
  }) {
    final context = NavigationService.navigationKey.currentContext;
    if (context == null) {
      return;
    }

    final defaultMargin = position == ToastPosition.bottom
        ? EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w)
        : EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w);

    final snackBar = SnackBar(
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      dismissDirection: dismissOnTap
          ? DismissDirection.horizontal
          : DismissDirection.none,
      padding: EdgeInsets.zero,
      margin: margin ?? defaultMargin,

      content: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Material(
            color: backgroundColor ?? appColors.primary,
            elevation: elevation,
            borderRadius: BorderRadius.circular(radius),

            child: Padding(
              padding:
                  padding ??
                  EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor ?? customColors.blackWhite),
                    10.horizontalSpace,
                  ],
                  TextWidget(
                    word: text,
                    textColor: textColor ?? customColors.blackWhite,
                    size: 16.sp,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar
      ..showSnackBar(snackBar);
  }
}
