import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/features/settings/cubit/settings_cubit.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/widgets/category_dropdown.dart';
import 'package:todo_clean_solid/widgets/list_view_category.dart';
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
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            title: Text(
              title,
              style: appTextStyle.getQuicksand(MyFontWeight.semiBold),
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(10),
                const SizedBox(
                  height: 50,
                  child: ListViewCategory(),
                ),
                todos.isNotEmpty
                    ? ListView.builder(
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
                                    // performsFirstActionWithFullSwipe: true, // this is the same as iOS native
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onTap: (CompletionHandler handler) async {
                                      final updatedTodo = await _showEditTodoDialog(context, todos[i]);
                                      if (updatedTodo != null) {
                                        if (!context.mounted) return;
                                        context.read<TodoCubit>().updateTodo(todos[i].id, updatedTodo);
                                        context.read<TodoCubit>().getTodosByCategory(updatedTodo.category);
                                      }
                                    },
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                  ),
                                ],
                                child: ListTile(
                                  leading: Checkbox(
                                    value: todos[i].isCompleted,
                                    onChanged: (value) {
                                      context.read<TodoCubit>().toggleTodoStatus(todos[i].id, value!);
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
                                            style: appTextStyle.getQuicksand(MyFontWeight.medium).copyWith(
                                                  color: context.read<TodoCubit>().getColorForTodoPriority(todos[i]),
                                                ),
                                          ),
                                          Text(
                                            'Category: ${todos[i].category.name}',
                                            style: appTextStyle.getQuicksand(MyFontWeight.light),
                                          ),
                                        ],
                                      ),
                                      BlocBuilder<SettingsCubit, SettingsState>(
                                        builder: (context, state) {
                                          return Visibility(
                                            visible: state.isDateTimeEnabled,
                                            child: Text(
                                              todos[i].dateTimestamp,
                                              style: appTextStyle
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
                                          context.read<TodoCubit>().deleteTodo(todos[i].id);
                                          Navigator.pop(context);
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
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
                      )
                    : Center(
                        child: Text(
                          'Nothing to display',
                          style: appTextStyle.getQuicksand(MyFontWeight.semiBold),
                        ),
                      ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            onPressed: () async {
              // context.read<TodoCubit>().getTodosByCategory(TodoCategory.All);
              final todo = await _showAddTodoDialog(context);
              if (todo != null) {
                if (!context.mounted) return;
                context.read<TodoCubit>().addNewTodo(todo);
                context.read<TodoCubit>().getTodosByCategory(todo.category);
              }
            },
            tooltip: 'Add Todo',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<Todo?> _showAddTodoDialog(BuildContext context) async {
    myController.text = "";
    var selectedPriorityTodo = TodoPriority.Low;
    var selectedCategoryTodo = TodoCategory.All;
    Todo? todo;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                16,
              ),
              topRight: Radius.circular(
                16,
              ),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  bottom: 16,
                ),
                child: Text(
                  "Add Todo",
                  style: appTextStyle.getQuicksand(MyFontWeight.medium),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
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
                                  hintStyle: appTextStyle.getQuicksand(MyFontWeight.regular),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category:',
                            style: appTextStyle.getQuicksand(MyFontWeight.medium),
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
                            style: appTextStyle.getQuicksand(MyFontWeight.medium),
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
                              style: appTextStyle.getQuicksand(MyFontWeight.medium),
                            ),
                            onPressed: () {
                              String enteredText = myController.text;
                              if (enteredText != "") {
                                var now = DateTime.now();
                                var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                                String formattedDate = formatter.format(now);
                                todo = Todo(
                                  // id: uuid.v4().toString(),
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    return todo;
  }

  Future<Todo?> _showEditTodoDialog(BuildContext context, Todo todo) async {
    myController.text = todo.title;
    var selectedPriorityTodo = todo.priority;
    var selectedCategoryTodo = todo.category;

    return await showModalBottomSheet<Todo?>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                width: double.maxFinite,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  bottom: 16,
                ),
                child: Text(
                  "Edit Todo",
                  style: appTextStyle.getQuicksand(MyFontWeight.medium),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
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
                                  hintStyle: appTextStyle.getQuicksand(MyFontWeight.regular),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category:',
                            style: appTextStyle.getQuicksand(MyFontWeight.medium),
                          ),
                          CategoryDropdown(
                            selectedCategory: selectedCategoryTodo,
                            onChanged: (TodoCategory? selectedCategory) {
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
                            style: appTextStyle.getQuicksand(MyFontWeight.medium),
                          ),
                          PriorityDropdown(
                            selectedPriority: selectedPriorityTodo,
                            onChanged: (TodoPriority? selectedPriority) {
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
                              'Update',
                              style: appTextStyle.getQuicksand(MyFontWeight.medium),
                            ),
                            onPressed: () {
                              String enteredText = myController.text;
                              if (enteredText.isNotEmpty) {
                                //Update the todo with new values
                                todo.id = todo.id;
                                todo.title = enteredText;
                                todo.category = selectedCategoryTodo;
                                todo.priority = selectedPriorityTodo;
                              }
                              Navigator.pop(context, todo); // Return the updated todo
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
