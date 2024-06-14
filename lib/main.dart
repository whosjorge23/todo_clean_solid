import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_clean_solid/bootstrap.dart';
import 'package:todo_clean_solid/features/loading_screen/loading_screen.dart';
import 'package:todo_clean_solid/features/settings/cubit/settings_cubit.dart';
import 'package:todo_clean_solid/features/settings/settings_screen.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/features/todo_list/todo_list_screen.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:todo_clean_solid/shared_export.dart';

void main() async {
  await bootstrap();
  runApp(
    BlocProvider(
      create: (_) => SettingsCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Clean Todos',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.light(primary: appColors.blue),
            useMaterial3: true,
            floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: appColors.white),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: appColors.blue.withOpacity(0.7),
                foregroundColor: appColors.white,
                elevation: 0,
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.dark(primary: appColors.darkBlue),
            useMaterial3: true,
            floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: appColors.white),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: appColors.darkBlue.withOpacity(0.7),
                foregroundColor: appColors.white,
                elevation: 0,
              ),
            ),
          ),
          themeMode: state.themeMode,
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => MaterialPage(
                  child: LoadingScreen(),
                ),
              ),
              GoRoute(
                path: '/todo_list',
                pageBuilder: (context, state) => MaterialPage(
                  child: BlocProvider<TodoCubit>(
                    create: (context) => TodoCubit(),
                    child: TodoListScreen(
                      title: 'Clean Todos',
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => const MaterialPage(
                  child: SettingsScreen(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
