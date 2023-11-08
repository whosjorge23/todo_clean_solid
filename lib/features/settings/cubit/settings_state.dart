part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(false) bool isDateTimeEnabled,
  }) = _Initial;
}
