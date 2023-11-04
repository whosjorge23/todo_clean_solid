import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SettingsCubit extends Cubit<ThemeMode> {
  SettingsCubit() : super(ThemeMode.system); // starts with system theme

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      emit(ThemeMode.light);
    } else if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
    } else {
      // Toggle between light and dark when system theme is used
      emit(ThemeMode.dark);
    }
  }
}
