import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_clean_solid/services/shared_preferences_service.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerSingletons();
}

/// Create singletons (services) that can be shared across the app.
void _registerSingletons() {
  // Shared Preferences
  GetIt.I.registerLazySingleton<SharedPreferenceService>(() => SharedPreferenceService());
}
