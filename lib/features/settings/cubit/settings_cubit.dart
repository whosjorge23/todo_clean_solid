import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todo_clean_solid/shared_export.dart';

part 'settings_state.dart';

part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState.initial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    Locale? locale = await sharedPrefsService.getLocale() ?? const Locale('en');
    final themeMode = await sharedPrefsService.getValue<ThemeMode>('themeMode') ?? ThemeMode.system;
    final isDateTimeEnabled = await sharedPrefsService.getValue<bool>('isDateTimeEnable') ?? false;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    emit(state.copyWith(
        locale: locale,
        themeMode: themeMode,
        isDateTimeEnabled: isDateTimeEnabled,
        version: version,
        buildNumber: buildNumber));
  }

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
    sharedPrefsService.setValue<bool>('isDateTimeEnable', !state.isDateTimeEnabled);
    emit(state.copyWith(isDateTimeEnabled: !state.isDateTimeEnabled));
  }

  void setLocale(Locale locale) async {
    await sharedPrefsService.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
