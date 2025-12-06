import 'package:flutter/material.dart';

class ColorModel {
  final Color lightModeColor;
  final Color darkModeColor;

  const ColorModel({required this.lightModeColor, required this.darkModeColor});

  Color getColor(bool isDark) => isDark ? darkModeColor : lightModeColor;
}

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  static const ColorModel primary = ColorModel(
    lightModeColor: Color(0xFF2374E1),
    darkModeColor: Color(0xFF154687),
  );

  static const ColorModel secondary = ColorModel(
    lightModeColor: Color(0xFFFFC107),
    darkModeColor: Color(0xFFFFA000),
  );
  static const ColorModel backgroundColor = ColorModel(
    lightModeColor: Color(0xFFFFFFFF), // White
    darkModeColor: Color(0xFF090808), // Black
  );
  static const ColorModel textPrimary = ColorModel(
    lightModeColor: Color(0xFF000000),
    darkModeColor: Color(0xFFFFFFFF),
  );
}
