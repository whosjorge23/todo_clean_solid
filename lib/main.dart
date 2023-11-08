import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_solid/bootstrap.dart';
import 'package:todo_clean_solid/features/settings/cubit/settings_cubit.dart';
import 'package:todo_clean_solid/features/settings/settings_screen.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/features/todo_list/todo_list_screen.dart';

void main() async {
  await bootstrap();
  runApp(BlocProvider(
    create: (_) => SettingsCubit(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: state.themeMode,
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) => MaterialPage(
                  child: BlocProvider<TodoCubit>(
                    create: (context) => TodoCubit(),
                    child: TodoListScreen(
                      title: 'Flutter Todo Clean Solid',
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
