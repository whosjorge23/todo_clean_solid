import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_clean_solid/shared_export.dart';

part 'settings_state.dart';

part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState.initial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final themeMode = await sharedPrefsService.getValue<ThemeMode>('themeMode') ?? ThemeMode.system;
    final isDateTimeEnabled = await sharedPrefsService.getValue<bool>('isDateTimeEnable') ?? false;
    emit(state.copyWith(
      themeMode: themeMode,
      isDateTimeEnabled: isDateTimeEnabled,
    ));
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

  Future<void> toggleTheme(ThemeMode themeMode) async {
    if (themeMode == ThemeMode.dark) {
      sharedPrefsService.setValue<ThemeMode>('themeMode', ThemeMode.dark);
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else if (themeMode == ThemeMode.light) {
      sharedPrefsService.setValue<ThemeMode>('themeMode', ThemeMode.light);
      emit(state.copyWith(themeMode: ThemeMode.light));
    } else {
      sharedPrefsService.setValue<ThemeMode>('themeMode', ThemeMode.system);
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  Future<void> toggleDateTime() async {
    if (state.isDateTimeEnabled != null) {
      sharedPrefsService.setValue<bool>('isDateTimeEnable', !state.isDateTimeEnabled);
      emit(state.copyWith(isDateTimeEnabled: !state.isDateTimeEnabled));
    }
  }
}
