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
import 'package:todo_clean_solid/services/context_extension.dart';
import 'package:todo_clean_solid/widgets/category_dropdown.dart';
import 'package:todo_clean_solid/widgets/list_view_category.dart';
import 'package:todo_clean_solid/widgets/priority_chip.dart';
import 'package:todo_clean_solid/widgets/reusable_alert_dialog.dart';
import 'package:todo_clean_solid/widgets/priority_dropdown.dart';
import 'package:uuid/uuid.dart';

import '../../shared_export.dart';
import '../../widgets/category_chip.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  Random random = Random();

  final myController = TextEditingController();

  var uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final todosCubit = context.watch<TodoCubit>();
    final todosCubitState = context.watch<TodoCubit>().state;
    return todosCubitState.when(
      initial: (todos, selectedCategoryIndex, selectedAddCategoryIndex, selectedAddPriorityIndex,
          selectedEditCategoryIndex, selectedEditPriorityIndex) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            title: Text(
              widget.title,
              style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(color: appColors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/settings');
                },
                icon: Icon(
                  Icons.settings,
                  color: appColors.white,
                ),
              )
            ],
          ),
          body: Column(
            children: [
              const Gap(10),
              const SizedBox(
                height: 50,
                child: ListViewCategory(),
              ),
              Expanded(
                child: todos.isNotEmpty
                    ? ListView.builder(
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
                                    closeOnTap: true,
                                    onTap: (CompletionHandler handler) async {
                                      final updatedTodo = await _showEditTodoDialog(context, todos[i], todosCubit);
                                      if (updatedTodo != null) {
                                        if (!context.mounted) return;
                                        context.read<TodoCubit>().updateTodo(todos[i].id, updatedTodo);
                                        await context.read<TodoCubit>().getTodosByCategory(updatedTodo.category);
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
                                            '${context.l10n.category}: ${getTranslatedCategory(todos[i].category.name)}',
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
                                        title: context.l10n.delete_todo,
                                        content: context.l10n.are_you_sure,
                                        confirmButtonText: context.l10n.generic_yes,
                                        cancelButtonText: context.l10n.generic_no,
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
                          context.l10n.nothing_to_display,
                          style: appTextStyle.getQuicksand(MyFontWeight.semiBold),
                        ),
                      ),
              ),
              const Gap(50),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            onPressed: () async {
              final todo = await _showAddTodoDialog(context, selectedCategoryIndex, todosCubit);
              if (todo != null) {
                if (!context.mounted) return;
                context.read<TodoCubit>().addNewTodo(todo);
                context.read<TodoCubit>().getTodosByCategory(todo.category);
              }
            },
            tooltip: context.l10n.add_todo,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<Todo?> _showAddTodoDialog(BuildContext context, int index, TodoCubit todosCubit) async {
    myController.text = "";
    var selectedPriorityTodo = TodoPriority.Low;
    var selectedCategoryTodo = TodoCategory.values[index];
    Todo? todo;
    Brightness currentBrightness = Theme.of(context).brightness;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return BlocProvider.value(
          value: todosCubit,
          child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
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
                        context.l10n.add_todo,
                        style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(color: appColors.white),
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
                                        labelText: context.l10n.enter_todo,
                                        labelStyle: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                                            color: currentBrightness == Brightness.dark ? appColors.white : null),
                                        hintText: context.l10n.enter_todo,
                                        hintStyle: appTextStyle.getQuicksand(MyFontWeight.regular),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${context.l10n.category}:',
                                      style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                                          color: currentBrightness == Brightness.light ? appColors.blue : null),
                                    ),
                                    // CategoryDropdown(
                                    //   selectedCategory: TodoCategory.values[index],
                                    //   onChanged: (TodoCategory? selectedCategory) {
                                    //     // Handle the selected priority here
                                    //     if (selectedCategory != null) {
                                    //       selectedCategoryTodo = selectedCategory;
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      bool isSelected = index == state.selectedAddCategoryIndex;
                                      return CategoryChip(
                                        onTap: () {
                                          todosCubit.updateAddCategoryIndex(index);
                                          selectedCategoryTodo = TodoCategory.values[index];
                                        },
                                        isSelected: isSelected,
                                        category: TodoCategory.values[index],
                                        currentBrightness: currentBrightness,
                                      );
                                    },
                                    itemCount: TodoCategory.values.length,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${context.l10n.priority}:',
                                      style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                                          color: currentBrightness == Brightness.light ? appColors.blue : null),
                                    ),
                                    // PriorityDropdown(
                                    //   onChanged: (TodoPriority? selectedPriority) {
                                    //     // Handle the selected priority here
                                    //     if (selectedPriority != null) {
                                    //       selectedPriorityTodo = selectedPriority;
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      bool isSelected = index == state.selectedAddPriorityIndex;
                                      return PriorityChip(
                                        onTap: () {
                                          todosCubit.updateAddPriorityIndex(index);
                                          selectedPriorityTodo = TodoPriority.values[index];
                                        },
                                        isSelected: isSelected,
                                        priority: TodoPriority.values[index],
                                        currentBrightness: currentBrightness,
                                      );
                                    },
                                    itemCount: TodoPriority.values.length,
                                  ),
                                ),
                              ],
                            ),
                            Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: Text(
                                      context.l10n.generic_add,
                                      style: appTextStyle.getQuicksand(MyFontWeight.bold).copyWith(
                                          color: currentBrightness == Brightness.dark ? appColors.white : null),
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
          ),
        );
      },
    ).then((value) {
      todosCubit.updateAddCategoryIndex(0);
      todosCubit.updateAddPriorityIndex(0);
    });
    return todo;
  }

  Future<Todo?> _showEditTodoDialog(BuildContext context, Todo todo, TodoCubit todosCubit) async {
    myController.text = todo.title;
    var selectedPriorityTodo = todo.priority;
    var selectedCategoryTodo = todo.category;
    Brightness currentBrightness = Theme.of(context).brightness;

    return await showModalBottomSheet<Todo?>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: todosCubit,
          child: BlocConsumer<TodoCubit, TodoState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
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
                        context.l10n.edit_todo,
                        style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(color: appColors.white),
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
                                        hintText: context.l10n.update_todo,
                                        labelText: context.l10n.update_todo,
                                        labelStyle: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                                            color: currentBrightness == Brightness.dark ? appColors.white : null),
                                        hintStyle: appTextStyle.getQuicksand(MyFontWeight.regular),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${context.l10n.category}:',
                                      style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                                          color: currentBrightness == Brightness.light ? appColors.blue : null),
                                    ),
                                    // CategoryDropdown(
                                    //   selectedCategory: selectedCategoryTodo,
                                    //   onChanged: (TodoCategory? selectedCategory) {
                                    //     if (selectedCategory != null) {
                                    //       selectedCategoryTodo = selectedCategory;
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      bool isSelected = state.selectedEditCategoryIndex != null
                                          ? index == state.selectedEditCategoryIndex
                                          : index == selectedCategoryTodo.index;
                                      return CategoryChip(
                                        onTap: () {
                                          todosCubit.updateEditCategoryIndex(index);
                                          selectedCategoryTodo = TodoCategory.values[index];
                                        },
                                        isSelected: isSelected,
                                        category: TodoCategory.values[index],
                                        currentBrightness: currentBrightness,
                                      );
                                    },
                                    itemCount: TodoCategory.values.length,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${context.l10n.priority}:',
                                      style: appTextStyle.getQuicksand(MyFontWeight.semiBold).copyWith(
                                          color: currentBrightness == Brightness.light ? appColors.blue : null),
                                    ),
                                    // PriorityDropdown(
                                    //   selectedPriority: selectedPriorityTodo,
                                    //   onChanged: (TodoPriority? selectedPriority) {
                                    //     if (selectedPriority != null) {
                                    //       selectedPriorityTodo = selectedPriority;
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      bool isSelected = state.selectedEditPriorityIndex != null
                                          ? index == state.selectedEditPriorityIndex
                                          : index == selectedPriorityTodo.index;
                                      return PriorityChip(
                                        onTap: () {
                                          todosCubit.updateEditPriorityIndex(index);
                                          selectedPriorityTodo = TodoPriority.values[index];
                                        },
                                        isSelected: isSelected,
                                        priority: TodoPriority.values[index],
                                        currentBrightness: currentBrightness,
                                      );
                                    },
                                    itemCount: TodoPriority.values.length,
                                  ),
                                ),
                              ],
                            ),
                            Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    child: Text(
                                      context.l10n.generic_update,
                                      style: appTextStyle.getQuicksand(MyFontWeight.bold).copyWith(
                                          color: currentBrightness == Brightness.dark ? appColors.white : null),
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
                                      context.pop();
                                    },
                                  ),
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
          ),
        );
      },
    ).then((value) {
      todosCubit.resetEditPriorityAndCategory();
      return todo;
    });
  }

  String getTranslatedCategory(String category) {
    switch (category) {
      case "All":
        return context.l10n.category_all;
      case "Grocery":
        return context.l10n.category_grocery;
      case "Shopping":
        return context.l10n.category_shopping;
      case "Todo":
        return context.l10n.category_todo;
      case "CheckList":
        return context.l10n.category_checklist;
      default:
        return category; // Fallback to the original category name
    }
  }
}
