import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/services/context_service.dart';
import 'package:todo_clean_solid/services/shared_preferences_service.dart';
import 'package:todo_clean_solid/theme/app_colors.dart';

ContextService get contextService => GetIt.I.get<ContextService>();

BuildContext get globalContext => contextService.context;

SharedPreferenceService get sharedPrefsService => GetIt.I.get<SharedPreferenceService>();

QuicksandTextStyle get appTextStyle => GetIt.I.get<QuicksandTextStyle>();

AppColors get appColors => GetIt.I.get<AppColors>();
