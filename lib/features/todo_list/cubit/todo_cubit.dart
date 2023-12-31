import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
      debugPrint("list Todo Add: ${await sharedPrefsService.getObjectsList("todos")}");
    }
  }

  Future<void> updateTodo(int index, Todo updatedTodo) async {
    List<Todo> todoList = List.from(state.todos);
    if (index >= 0 && index < todoList.length) {
      todoList[index] = updatedTodo;
      emit(state.copyWith(todos: todoList));
      sharedPrefsService.removeValue('todos');
      sharedPrefsService.saveObjectsList("todos", todoList);
      debugPrint("list Todo Update: ${await sharedPrefsService.getObjectsList("todos")}");
    } else {
      debugPrint("Invalid index for updating Todo");
    }
  }

  Future<void> deleteTodo(int index) async {
    List<Todo> todoList = List.from(state.todos);
    todoList.removeAt(index);
    emit(state.copyWith(todos: todoList));
    sharedPrefsService.removeValue('todos');
    sharedPrefsService.saveObjectsList("todos", todoList);
    debugPrint("list Todo Delete: ${await sharedPrefsService.getObjectsList("todos")}");
  }

  Future<void> toggleTodoStatus(int index, bool isChecked) async {
    List<Todo> todoList = List.from(state.todos);
    final updatedTodo = todoList.elementAt(index).copyWith(isCompleted: isChecked);
    todoList[index] = updatedTodo;
    emit(state.copyWith(todos: todoList));
    sharedPrefsService.removeValue('todos');
    sharedPrefsService.saveObjectsList("todos", todoList);
    debugPrint("list Todo Update: ${await sharedPrefsService.getObjectsList("todos")}");
  }

  Future<void> getTodosByCategory(TodoCategory category) async {
    List<Todo> listTodo = await sharedPrefsService.getObjectsList("todos") ?? [];

    List<Todo> filteredTodos;
    if (category == TodoCategory.All) {
      filteredTodos = listTodo;
    } else {
      filteredTodos = listTodo.where((todo) => todo.category == category).toList();
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
}
