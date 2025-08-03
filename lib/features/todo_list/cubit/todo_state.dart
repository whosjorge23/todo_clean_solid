part of 'todo_cubit.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final int selectedCategoryIndex;
  final int selectedAddCategoryIndex;
  final int selectedAddPriorityIndex;
  final int? selectedEditCategoryIndex;
  final int? selectedEditPriorityIndex;

  const TodoState({
    this.todos = const [],
    this.selectedCategoryIndex = 0,
    this.selectedAddCategoryIndex = 0,
    this.selectedAddPriorityIndex = 0,
    this.selectedEditCategoryIndex,
    this.selectedEditPriorityIndex,
  });

  TodoState copyWith({
    List<Todo>? todos,
    int? selectedCategoryIndex,
    int? selectedAddCategoryIndex,
    int? selectedAddPriorityIndex,
    int? selectedEditCategoryIndex,
    int? selectedEditPriorityIndex,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedAddCategoryIndex:
          selectedAddCategoryIndex ?? this.selectedAddCategoryIndex,
      selectedAddPriorityIndex:
          selectedAddPriorityIndex ?? this.selectedAddPriorityIndex,
      selectedEditCategoryIndex:
          selectedEditCategoryIndex ?? this.selectedEditCategoryIndex,
      selectedEditPriorityIndex:
          selectedEditPriorityIndex ?? this.selectedEditPriorityIndex,
    );
  }

  @override
  List<Object?> get props => [
        todos,
        selectedCategoryIndex,
        selectedAddCategoryIndex,
        selectedAddPriorityIndex,
        selectedEditCategoryIndex,
        selectedEditPriorityIndex,
      ];
}
