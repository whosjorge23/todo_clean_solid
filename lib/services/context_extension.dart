import 'package:flutter/material.dart';
import 'package:todo_clean_solid/l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;
}
