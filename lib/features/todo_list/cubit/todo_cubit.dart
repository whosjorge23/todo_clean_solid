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
  final Isar isar;

  TodoCubit(this.isar) : super(const TodoState.initial()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final listTodo = await isar.todos.where().findAll();
    emit(state.copyWith(todos: listTodo));
  }

  Future<void> addNewTodo(Todo todo) async {
    List<Todo> filteredTodos;
    await isar.writeTxn(() async {
      await isar.todos.put(todo);
    });
    filteredTodos = await isar.todos.filter().categoryEqualTo(todo.category).findAll();

    emit(state.copyWith(todos: filteredTodos, selectedCategoryIndex: todo.category.index));
  }

  Future<void> updateTodo(int id, Todo updatedTodo) async {
    List<Todo> filteredTodos;
    await isar.writeTxn(() async {
      await isar.todos.put(updatedTodo);
    });
    filteredTodos = await isar.todos.filter().categoryEqualTo(updatedTodo.category).findAll();
    emit(state.copyWith(todos: filteredTodos, selectedCategoryIndex: updatedTodo.category.index));
  }

  Future<void> deleteTodo(int id) async {
    List<Todo> filteredTodos;
    await isar.writeTxn(() async {
      final todo = await isar.todos.get(id);
      await isar.todos.delete(id);
      if (todo == null) return;
      filteredTodos = await isar.todos.filter().categoryEqualTo(todo.category).findAll();
      emit(state.copyWith(todos: filteredTodos, selectedCategoryIndex: todo.category.index));
    });
  }

  Future<void> toggleTodoStatus(int id, bool isChecked) async {
    List<Todo> filteredTodos;
    await isar.writeTxn(() async {
      final todo = await isar.todos.get(id);
      if (todo == null) return;
      todo.isCompleted = isChecked;
      await isar.todos.put(todo);
      filteredTodos = await isar.todos.filter().categoryEqualTo(todo.category).findAll();
      emit(state.copyWith(todos: filteredTodos, selectedCategoryIndex: todo.category.index));
    });
  }

  Future<void> getTodosByCategory(TodoCategory category) async {
    List<Todo> filteredTodos;
    if (category == TodoCategory.All) {
      filteredTodos = await isar.todos.where().findAll();
    } else {
      filteredTodos = await isar.todos.filter().categoryEqualTo(category).findAll();
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

  Future<void> updateCategoryIndex(int index) async {
    emit(state.copyWith(selectedCategoryIndex: index));
  }
}
