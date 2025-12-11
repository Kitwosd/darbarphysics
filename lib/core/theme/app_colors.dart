import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color whiteGrey;
  final Color whiteDarkGrey;
  final Color greyWhite;

  const AppColors({
    required this.whiteGrey,
    required this.whiteDarkGrey,
    required this.greyWhite,
  });

  @override
  AppColors copyWith({
    Color? whiteGrey,
    Color? whiteDarkGrey,
    Color? greyWhite,
  }) {
    return AppColors(
      whiteGrey: whiteGrey ?? this.whiteGrey,
      whiteDarkGrey: whiteDarkGrey ?? this.whiteDarkGrey,
      greyWhite: this.greyWhite,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      whiteGrey: Color.lerp(whiteGrey, other.whiteGrey, t)!,
      whiteDarkGrey: Color.lerp(whiteDarkGrey, other.whiteDarkGrey, t)!,
      greyWhite: Color.lerp(greyWhite, other.greyWhite, t)!,
    );
  }
}
