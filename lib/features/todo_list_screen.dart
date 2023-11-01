import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_solid/features/cubit/todo_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_clean_solid/extension/text_style.dart';
import 'package:todo_clean_solid/widgets/priority_dropdown.dart';
import 'package:uuid/uuid.dart';

class TodoListScreen extends StatelessWidget {
  TodoListScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  Random random = Random();
  final myController = TextEditingController();
  var uuid = const Uuid();
  final myTextStyle = const TextStyle();

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
              style: myTextStyle.getQuicksandSemiBold(),
            ),
          ),
          body: todos.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                  style: myTextStyle
                                      .getQuicksandMedium()
                                      .copyWith(color: context.read<TodoCubit>().getColorForTodoPriority(todos[i])),
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
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'Nothing to display',
                    style: myTextStyle.getQuicksandSemiBold(),
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
    var selectedPriorityTodo = TodoPriority.low;
    late Todo todo;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Todo',
            style: myTextStyle.getQuicksandMedium(),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Container(
              height: 70,
              child: Column(
                children: [
                  TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your todo',
                      hintStyle: myTextStyle.getQuicksandRegular(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            PriorityDropdown(
              onChanged: (TodoPriority? selectedPriority) {
                // Handle the selected priority here
                if (selectedPriority != null) {
                  selectedPriorityTodo = selectedPriority;
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                'Add',
                style: myTextStyle.getQuicksandMedium(),
              ),
              onPressed: () {
                String enteredText = myController.text;
                if (enteredText != "") {
                  todo = Todo(
                      id: uuid.v4().toString(), title: enteredText, isCompleted: false, priority: selectedPriorityTodo);
                }
                context.pop();
              },
            ),
          ],
        );
      },
    );
    return todo;
  }
}
