import 'package:isar/isar.dart';
import 'package:todo_clean_solid/constants/todo_constants.dart';

part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement; // Automatically handled by Isar

  late String title; // Ensure these are initialized
  late bool isCompleted;
  late String dateTimestamp;

  @Enumerated(EnumType.name) // Consistent with how enums are defined
  late TodoPriority priority;
  @Enumerated(EnumType.name)
  late TodoCategory category;

  Todo({
    required this.title,
    required this.isCompleted,
    required this.dateTimestamp,
    required this.priority,
    required this.category,
  });
}
