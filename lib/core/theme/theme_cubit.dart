import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.system) {
      emit(ThemeMode.dark);
    } else if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.dark);
    }
  }

  void setLight() => emit(ThemeMode.light);
  void setDark() => emit(ThemeMode.dark);
  void setSystem() => emit(ThemeMode.system);
}
