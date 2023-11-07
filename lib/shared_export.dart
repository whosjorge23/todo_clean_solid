import 'package:get_it/get_it.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/services/shared_preferences_service.dart';

SharedPreferenceService get sharedPrefsService => GetIt.I.get<SharedPreferenceService>();

QuicksandTextStyle get quickSandTextStyle => GetIt.I.get<QuicksandTextStyle>();
