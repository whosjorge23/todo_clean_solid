import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_clean_solid/features/cubit/todo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:provider/provider.dart';
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
            title: Text(title),
          ),
          body: todos.isNotEmpty
              ? ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Checkbox(
                        value: todos[i].isCompleted,
                        onChanged: (value) {
                          context.read<TodoCubit>().toggleTodoStatus(i, value!);
                        },
                      ),
                      title: Text(todos[i].title),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.read<TodoCubit>().deleteTodo(i);
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Nothing to display'),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final todo = await _dialogBuilder(context);
              context.read<TodoCubit>().addNewTodo(todo);
            },
            tooltip: 'Add Todo',
            child: const Icon(Icons.add),
          ),
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
          title: const Text('Add Todo'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your todo',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Add'),
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
