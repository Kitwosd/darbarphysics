import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color whiteGrey;
  final Color whiteDarkGrey;
  final Color greyWhite;
  final Color blackWhite;
  final Color whiteBlack;
  final Color logoColor;

  const AppColors({
    required this.whiteGrey,
    required this.whiteDarkGrey,
    required this.greyWhite,
    required this.blackWhite,
    required this.whiteBlack,
    required this.logoColor,
  });

  @override
  AppColors copyWith({
    Color? whiteGrey,
    Color? whiteDarkGrey,
    Color? greyWhite,
    Color? blackWhite,
    Color? whiteBlack,
    Color? logoColor,
  }) {
    return AppColors(
      whiteGrey: whiteGrey ?? this.whiteGrey,
      whiteDarkGrey: whiteDarkGrey ?? this.whiteDarkGrey,
      greyWhite: greyWhite ?? this.greyWhite,
      blackWhite: blackWhite ?? this.blackWhite,
      whiteBlack: whiteBlack ?? this.whiteBlack,
      logoColor: logoColor ?? this.logoColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      whiteGrey: Color.lerp(whiteGrey, other.whiteGrey, t)!,
      whiteDarkGrey: Color.lerp(whiteDarkGrey, other.whiteDarkGrey, t)!,
      greyWhite: Color.lerp(greyWhite, other.greyWhite, t)!,
      blackWhite: Color.lerp(blackWhite, other.blackWhite, t)!,
      whiteBlack: Color.lerp(whiteBlack, other.whiteBlack, t)!,
      logoColor: Color.lerp(logoColor, other.logoColor, t)!,

    );
  }
}
