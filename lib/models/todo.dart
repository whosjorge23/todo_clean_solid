import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_clean_solid/features/todo_list/cubit/todo_cubit.dart';

part 'todo.freezed.dart';

part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required bool isCompleted,
    required String dateTimestamp,
    required TodoPriority priority,
    required String category,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
