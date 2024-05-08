part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(Locale('en')) locale,
    @Default(false) bool isDateTimeEnabled,
    @Default("1.0") String version,
    @Default("1") String buildNumber,
  }) = _Initial;
}
