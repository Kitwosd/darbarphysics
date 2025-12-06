import 'package:flutter/material.dart';

class AppColors {
  // Main branding color
  static const primary = Color(0xFF3787FF);
  // Accent color for secondary actions
  static const secondary = Color(0xFF34A853); // example, can update from Figma
  // Background of screens
  static const background = Color(0xFFE4F1F8);
  // Dark text color
  static const textDark = Color(0xFF212121);
  // Light text color
  static const textLight = Color(0xFFFFFFFF);
  // Error messages
  static const error = Color(0xFFB00020);
  //Grey textc color
  static const textGrey = Color(0xFF767372);
}

class AppTextStyles {
  // Headings
  static const heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // Body text
  static const body = TextStyle(fontSize: 16, color: AppColors.textDark);

  // Button text
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textLight,
  );
}
