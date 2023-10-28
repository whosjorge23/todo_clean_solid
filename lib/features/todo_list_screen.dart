import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_clean_solid/features/cubit/todo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_solid/models/todo.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  Random random = Random();
  final myController = TextEditingController();

  String getRandomId() {
    double randomDouble = random.nextDouble();
    return randomDouble.toString();
  }

  @override
  Widget build(BuildContext context) {
    final todosCubitState = context.watch<TodoCubit>().state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: todosCubitState.when(
        initial: (todos) {
          if (todos.isNotEmpty) {
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Checkbox(
                    value: todos[i].isCompleted,
                    onChanged: (value) {
                      context.read<TodoCubit>().toggleTodoStatus(todos[i]);
                    },
                  ),
                  title: Text(todos[i].title),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _dialogBuilder(context);
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    myController.text = "";
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController, // Set the controller here
              decoration: InputDecoration(
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
                String enteredText = myController.text; // Get the text from the controller
                if (enteredText != "") {
                  context.read<TodoCubit>().addNewTodo(Todo(id: getRandomId(), title: enteredText, isCompleted: false));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
