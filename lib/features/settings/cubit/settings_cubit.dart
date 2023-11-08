import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.dart';

part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState.initial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(themeMode: ThemeMode.system, isDateTimeEnabled: false));
  }

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
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else if (themeMode == ThemeMode.light) {
      emit(state.copyWith(themeMode: ThemeMode.light));
    } else {
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  void toggleDateTime() {
    if (state.isDateTimeEnabled != null) {
      emit(state.copyWith(isDateTimeEnabled: !state.isDateTimeEnabled!));
    }
  }
}
