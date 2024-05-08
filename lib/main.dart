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
  final isar = await Isar.open(
    [TodoSchema],
    directory: (await getApplicationSupportDirectory()).path,
  );
  runApp(
    BlocProvider(
      create: (_) => SettingsCubit(),
      child: MyApp(isar: isar),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Isar isar; // Declare a variable to hold Isar instance

  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Clean Todos',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(primary: Color(0xff114A5D)),
            useMaterial3: true,
            floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: appColors.white),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(primary: Color(0xff294a6e)),
            useMaterial3: true,
            floatingActionButtonTheme: FloatingActionButtonThemeData(foregroundColor: appColors.white),
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
                    create: (context) => TodoCubit(isar),
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
