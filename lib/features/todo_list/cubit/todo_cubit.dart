import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:todo_clean_solid/shared_export.dart';

part 'todo_state.dart';

part 'todo_cubit.freezed.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState.initial()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final listTodo = await isarService.isar.todos.where().findAll();
    emit(state.copyWith(todos: listTodo));
  }

  Future<void> addNewTodo(Todo todo) async {
    List<Todo> filteredTodos;
    await isarService.isar.writeTxn(() async {
      await isarService.isar.todos.put(todo);
    });
    if (state.selectedCategoryIndex == 0) {
      filteredTodos = await isarService.isar.todos.where().findAll();
    } else {
      filteredTodos = await isarService.isar.todos.filter().categoryEqualTo(todo.category).findAll();
    }
    emit(state.copyWith(todos: filteredTodos));
  }

  Future<void> updateTodo(int id, Todo updatedTodo) async {
    List<Todo> filteredTodos;
    await isarService.isar.writeTxn(() async {
      await isarService.isar.todos.put(updatedTodo);
    });
    if (state.selectedCategoryIndex == 0) {
      filteredTodos = await isarService.isar.todos.where().findAll();
    } else {
      filteredTodos = await isarService.isar.todos.filter().categoryEqualTo(updatedTodo.category).findAll();
    }
    emit(state.copyWith(todos: filteredTodos, selectedCategoryIndex: updatedTodo.category.index));
    await getTodosByCategory(TodoCategory.values[state.selectedCategoryIndex]);
  }

  Future<void> deleteTodo(int id) async {
    List<Todo> filteredTodos;
    await isarService.isar.writeTxn(() async {
      final todo = await isarService.isar.todos.get(id);
      await isarService.isar.todos.delete(id);
      if (todo == null) return;
      if (state.selectedCategoryIndex == 0) {
        filteredTodos = await isarService.isar.todos.where().findAll();
      } else {
        filteredTodos = await isarService.isar.todos.filter().categoryEqualTo(todo.category).findAll();
      }
      emit(state.copyWith(todos: filteredTodos));
    });
  }

  Future<void> toggleTodoStatus(int id, bool isChecked) async {
    List<Todo> filteredTodos;
    await isarService.isar.writeTxn(() async {
      final todo = await isarService.isar.todos.get(id);
      if (todo == null) return;
      todo.isCompleted = isChecked;
      await isarService.isar.todos.put(todo);
      if (state.selectedCategoryIndex == 0) {
        filteredTodos = await isarService.isar.todos.where().findAll();
      } else {
        filteredTodos = await isarService.isar.todos.filter().categoryEqualTo(todo.category).findAll();
      }
      emit(state.copyWith(todos: filteredTodos));
    });
  }

  Future<void> getTodosByCategory(TodoCategory category) async {
    List<Todo> filteredTodos;
    if (category == TodoCategory.All) {
      filteredTodos = await isarService.isar.todos.where().findAll();
    } else {
      filteredTodos = await isarService.isar.todos.filter().categoryEqualTo(category).findAll();
    }
    emit(state.copyWith(todos: filteredTodos));
  }

  Color getColorForTodoPriority(Todo todo) {
    final priorityColors = {
      TodoPriority.Low: appColors.green,
      TodoPriority.Medium: appColors.yellow,
      TodoPriority.High: appColors.orange,
      TodoPriority.Maximum: appColors.red,
    };
    // Get the color based on the priority of the Todo
    return priorityColors[todo.priority] ?? Colors.grey;
  }

  void updateSelectedCategoryIndex(int index) {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  Future<void> updateCategoryIndex(int index) async {
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  Future<void> updateAddCategoryIndex(int index) async {
    emit(state.copyWith(selectedAddCategoryIndex: index));
  }

  Future<void> updateAddPriorityIndex(int index) async {
    emit(state.copyWith(selectedAddPriorityIndex: index));
  }

  Future<void> updateEditCategoryIndex(int index) async {
    emit(state.copyWith(selectedEditCategoryIndex: index));
  }

  Future<void> updateEditPriorityIndex(int index) async {
    emit(state.copyWith(selectedEditPriorityIndex: index));
  }

  void resetEditPriorityAndCategory() {
    emit(state.copyWith(selectedEditPriorityIndex: null, selectedEditCategoryIndex: null));
  }
}
