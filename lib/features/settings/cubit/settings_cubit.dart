import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SettingsCubit extends Cubit<ThemeMode> {
  SettingsCubit() : super(ThemeMode.system); // starts with system theme

  // void toggleTheme() {
  //   if (state == ThemeMode.dark) {
  //     emit(ThemeMode.light);
  //   } else if (state == ThemeMode.light) {
  //     emit(ThemeMode.dark);
  //   } else {
  //     // Toggle between light and dark when system theme is used
  //     emit(ThemeMode.dark);
  //   }
  // }

  void toggleTheme(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      emit(ThemeMode.dark);
    } else if (themeMode == ThemeMode.light) {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.system);
    }
  }
}
