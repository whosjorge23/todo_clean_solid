import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_clean_solid/models/todo.dart';
import 'package:todo_clean_solid/services/shared_preferences_service.dart';

part 'todo_state.dart';

part 'todo_cubit.freezed.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState.initial());

  Future<void> loadTodos() async {
    emit(state.copyWith(todos: []));
  }

  Future<void> addNewTodo(Todo? todo) async {
    List<Todo> todoList = List.from(state.todos);
    if (todo != null) {
      todoList.add(todo);
      emit(state.copyWith(todos: todoList));
    }
  }

  Future<void> toggleTodoStatus(int index, bool isChecked) async {
    List<Todo> todoList = List.from(state.todos);
    final updatedTodo = todoList.elementAt(index).copyWith(isCompleted: isChecked);
    todoList[index] = updatedTodo;
    emit(state.copyWith(todos: todoList));
  }

  Future<void> deleteTodo(int index) async {
    List<Todo> todoList = List.from(state.todos);
    todoList.removeAt(index);
    emit(state.copyWith(todos: todoList));
  }
}
