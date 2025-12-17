import 'package:durbar_physics/core/theme/app_colors.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xFF3787FF), //Brand primary
      secondary: Color(0xFFFF9D42), //brand secondary
      secondaryLightRef: Colors.white, // white in light
    ),

    //These are the custom colors
    extensions: const [
      AppColors(
        whiteGrey: Colors.white,
        whiteDarkGrey: Colors.white,
        greyWhite: Colors.grey,
        blackWhite: Colors.black,
      ),
    ],

    // 🌈 UI Blending (gives softer surfaces)
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,

    // 🧩 Sub-theme tweaks (IMPORTANT)
    subThemesData: const FlexSubThemesData(
      useMaterial3Typography: true,
      blendOnLevel: 10,

      // ✅ TextField better visuals
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorFocusedBorderWidth: 1.5,

      // ✅ Buttons
      elevatedButtonRadius: 10,
      outlinedButtonRadius: 10,

      // ✅ Cards & dialogs
      cardRadius: 12,
      dialogRadius: 14,

      // ✅ Switch, checkbox
      switchThumbSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      //primary: Color(0xFF543EE9), //Brand primary
      primary: Color(0xFF3787FF),
      secondary: Color(0xFF39D4D8), //Brand secondary

      secondaryLightRef: Color.fromARGB(255, 109, 108, 108),
    ),

    extensions: [
      AppColors(
        whiteGrey: Colors.grey,
        whiteDarkGrey: Colors.grey.shade700,
        greyWhite: Colors.white,
        blackWhite: Colors.white,
      ),
    ],
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,

    subThemesData: const FlexSubThemesData(
      useMaterial3Typography: true,
      blendOnLevel: 20,

      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: false,
      inputDecoratorFocusedBorderWidth: 1.5,

      elevatedButtonRadius: 10,
      outlinedButtonRadius: 10,
      cardRadius: 12,
      dialogRadius: 14,

      switchThumbSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
    ),
  );
}
