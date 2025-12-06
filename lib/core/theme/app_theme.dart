import 'package:dubar_physics/core/theme/app_themes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xFF2374E1),
      secondary: Color(0xFFFFC107),
    ),
    useMaterial3: true,
    
    scaffoldBackground: Colors.white,
    
  
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xFF2374E1),
      secondary: Color(0xFFFFC107),
    ),
    useMaterial3: true,
    scaffoldBackground: Colors.black87,
    
  );
}
