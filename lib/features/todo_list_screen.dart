import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_clean_solid/features/cubit/todo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_clean_solid/utils/text_style.dart';
import 'package:uuid/uuid.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  Random random = Random();
  final myController = TextEditingController();
  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final todosCubitState = context.watch<TodoCubit>().state;
    return todosCubitState.when(
      initial: (todos) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              title,
              style: getQuicksandSemiBold(),
            ),
          ),
          body: todos.isNotEmpty
              ? ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Checkbox(
                            value: todos[i].isCompleted,
                            onChanged: (value) {
                              context.read<TodoCubit>().toggleTodoStatus(i, value!);
                            },
                          ),
                          title: Text(
                            todos[i].title,
                            style: getQuicksandMedium(),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              context.read<TodoCubit>().deleteTodo(i);
                            },
                          ),
                        ),
                        const Divider()
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Nothing to display',
                    style: getQuicksandSemiBold(),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final todo = await _dialogBuilder(context);
              context.read<TodoCubit>().addNewTodo(todo);
            },
            tooltip: 'Add Todo',
            child: const Icon(Icons.add),
          ),
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
          //   child: TextField(
          //     controller: myController,
          //     decoration: const InputDecoration(
          //       // border: OutlineInputBorder(),
          //       hintText: 'Enter your todo',
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  Future<Todo?> _dialogBuilder(BuildContext context) async {
    myController.text = "";
    late Todo todo;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Todo',
            style: getQuicksandMedium(),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your todo',
                hintStyle: getQuicksandRegular(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Add',
                style: getQuicksandMedium(),
              ),
              onPressed: () {
                String enteredText = myController.text;
                if (enteredText != "") {
                  todo = Todo(id: uuid.v4().toString(), title: enteredText, isCompleted: false);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
    return todo;
  }
}
