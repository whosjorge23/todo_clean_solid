import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_solid/constants/todo_contants.dart';
import 'package:todo_clean_solid/features/settings/cubit/settings_cubit.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/widgets/category_dropdown.dart';
import 'package:todo_clean_solid/widgets/reusable_alert_dialog.dart';
import 'package:todo_clean_solid/widgets/priority_dropdown.dart';
import 'package:uuid/uuid.dart';

import '../../shared_export.dart';

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
              style: quickSandTextStyle.getQuicksand(MyFontWeight.semiBold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/settings');
                },
                icon: const Icon(Icons.settings),
              )
            ],
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
                              SwipeActionCell(
                                key: ObjectKey(i),
                                trailingActions: <SwipeAction>[
                                  SwipeAction(

                                      /// this is the same as iOS native
                                      performsFirstActionWithFullSwipe: true,
                                      icon: const Icon(
                                        Icons.delete_forever_rounded,
                                        color: Colors.white,
                                      ),
                                      onTap: (CompletionHandler handler) async {
                                        ReusableAlertDialog.show(
                                          context,
                                          title: 'Delete Todo',
                                          content: 'Are you sure you want to proceed?',
                                          confirmButtonText: 'YES',
                                          cancelButtonText: 'NO',
                                          onConfirm: () {
                                            context.read<TodoCubit>().deleteTodo(i);
                                            handler(false); // Close the cell and indicate the action is completed
                                            context.pop();
                                          },
                                          onCancel: () {
                                            context.pop();
                                            handler(false); // Close the cell without completing the action
                                          },
                                        );
                                      },
                                      color: appColors.red),
                                ],
                                child: ListTile(
                                  leading: Checkbox(
                                    value: todos[i].isCompleted,
                                    onChanged: (value) {
                                      context.read<TodoCubit>().toggleTodoStatus(i, value!);
                                    },
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            todos[i].title,
                                            style: quickSandTextStyle.getQuicksand(MyFontWeight.medium).copyWith(
                                                  color: context.read<TodoCubit>().getColorForTodoPriority(todos[i]),
                                                ),
                                          ),
                                          Text(
                                            'Category: ${todos[i].category.name}',
                                            style: quickSandTextStyle.getQuicksand(MyFontWeight.light),
                                          ),
                                        ],
                                      ),
                                      BlocBuilder<SettingsCubit, SettingsState>(
                                        builder: (context, state) {
                                          return Visibility(
                                            visible: state.isDateTimeEnabled,
                                            child: Text(
                                              todos[i].dateTimestamp,
                                              style: quickSandTextStyle
                                                  .getQuicksand(MyFontWeight.light)
                                                  .copyWith(color: Colors.grey),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      ReusableAlertDialog.show(
                                        context,
                                        title: 'Delete Todo',
                                        content: 'Are you sure you want to proceed?',
                                        confirmButtonText: 'YES',
                                        cancelButtonText: 'NO',
                                        onConfirm: () {
                                          context.read<TodoCubit>().deleteTodo(i);
                                          context.pop();
                                        },
                                        onCancel: () {
                                          context.pop();
                                        },
                                      );
                                    },
                                  ),
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
                    style: quickSandTextStyle.getQuicksand(MyFontWeight.semiBold),
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
    var selectedPriorityTodo = TodoPriority.Low;
    var selectedCategoryTodo = TodoCategory.All;
    late Todo todo;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Todo',
            style: quickSandTextStyle.getQuicksand(MyFontWeight.medium),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SizedBox(
              height: 70,
              child: Column(
                children: [
                  TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your todo',
                      hintStyle: quickSandTextStyle.getQuicksand(MyFontWeight.regular),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category:',
                  style: quickSandTextStyle.getQuicksand(MyFontWeight.medium),
                ),
                CategoryDropdown(
                  onChanged: (TodoCategory? selectedCategory) {
                    // Handle the selected priority here
                    if (selectedCategory != null) {
                      selectedCategoryTodo = selectedCategory;
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority:',
                  style: quickSandTextStyle.getQuicksand(MyFontWeight.medium),
                ),
                PriorityDropdown(
                  onChanged: (TodoPriority? selectedPriority) {
                    // Handle the selected priority here
                    if (selectedPriority != null) {
                      selectedPriorityTodo = selectedPriority;
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(
                    'Add',
                    style: quickSandTextStyle.getQuicksand(MyFontWeight.medium),
                  ),
                  onPressed: () {
                    String enteredText = myController.text;
                    if (enteredText != "") {
                      var now = DateTime.now();
                      var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                      String formattedDate = formatter.format(now);
                      todo = Todo(
                        id: uuid.v4().toString(),
                        title: enteredText,
                        isCompleted: false,
                        priority: selectedPriorityTodo,
                        dateTimestamp: formattedDate,
                        category: selectedCategoryTodo,
                      );
                    }
                    context.pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
    return todo;
  }
}
