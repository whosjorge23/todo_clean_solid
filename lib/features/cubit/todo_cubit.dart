import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_clean_solid/models/todo.dart';

part 'todo_state.dart';

part 'todo_cubit.freezed.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState.initial());

  List<Todo> todos = [];

  Future<void> loadTodos() async {
    emit(state.copyWith(todos: todos));
  }

  Future<void> addNewTodo(Todo todo) async {
    todos.add(todo);
    emit(state.copyWith(todos: todos));
  }

  Future<void> toggleTodoStatus(Todo todo) async {
    final updatedTodos = todos.map((td) {
      if (td.id == todo.id) {
        // Toggle the isCompleted property
        return td.copyWith(isCompleted: !td.isCompleted);
      }
      return td;
    }).toList();

    todos = updatedTodos;
    emit(state.copyWith(todos: updatedTodos));
  }
}
