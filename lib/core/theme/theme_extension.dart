import 'package:dubar_physics/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  //Get color form the AppColors easily
  Color appColor(ColorModel model) =>
      isDark ? model.darkModeColor : model.lightModeColor;
}
