import 'package:durbar_physics/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension ThemeExtension on BuildContext {
  void toggleTheme() {
    read<ThemeCubit>().toggleTheme();
  }

  ThemeMode get themeMode => watch<ThemeCubit>().state;

  bool get isDark {
    final mode = themeMode;

    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;

    // system mode
    return MediaQuery.of(this).platformBrightness == Brightness.dark;
  }
}
