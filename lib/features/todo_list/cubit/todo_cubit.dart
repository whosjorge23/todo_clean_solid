import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:todo_clean_solid/services/shared_preferences_service.dart';
import 'package:todo_clean_solid/shared_export.dart';

part 'todo_state.dart';

part 'todo_cubit.freezed.dart';

enum TodoPriority {
  low,
  medium,
  high,
  maximum,
}

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState.initial()) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    List<Todo> listTodo = await sharedPrefsService.getObjectsList("todos") ?? [];
    emit(state.copyWith(todos: listTodo));
  }

  Future<void> addNewTodo(Todo? todo) async {
    List<Todo> todoList = List.from(state.todos);
    if (todo != null) {
      todoList.add(todo);
      emit(state.copyWith(todos: todoList));
      sharedPrefsService.removeValue('todos');
      sharedPrefsService.saveObjectsList("todos", todoList);
      print("list Todo Add: ${await sharedPrefsService.getObjectsList("todos")}");
    }
  }

  Future<void> toggleTodoStatus(int index, bool isChecked) async {
    List<Todo> todoList = List.from(state.todos);
    final updatedTodo = todoList.elementAt(index).copyWith(isCompleted: isChecked);
    todoList[index] = updatedTodo;
    emit(state.copyWith(todos: todoList));
    sharedPrefsService.removeValue('todos');
    sharedPrefsService.saveObjectsList("todos", todoList);
    print("list Todo Update: ${await sharedPrefsService.getObjectsList("todos")}");
  }

  Future<void> deleteTodo(int index) async {
    List<Todo> todoList = List.from(state.todos);
    todoList.removeAt(index);
    emit(state.copyWith(todos: todoList));
    sharedPrefsService.removeValue('todos');
    sharedPrefsService.saveObjectsList("todos", todoList);
    print("list Todo Delete: ${await sharedPrefsService.getObjectsList("todos")}");
  }

  Color getColorForTodoPriority(Todo todo) {
    final priorityColors = {
      TodoPriority.low: Colors.green,
      TodoPriority.medium: Colors.amber,
      TodoPriority.high: Colors.orange,
      TodoPriority.maximum: Colors.red,
    };
    // Get the color based on the priority of the Todo
    return priorityColors[todo.priority] ?? Colors.grey;
  }

}