import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_solid/bootstrap.dart';
import 'package:todo_clean_solid/features/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/features/todo_list_screen.dart';

void main() async {
  await bootstrap();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
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
        ],
      ),
    );
  }
}
