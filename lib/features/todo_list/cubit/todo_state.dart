part of 'todo_cubit.dart';

@freezed
class TodoState with _$TodoState {
  const factory TodoState.initial({
    @Default([]) List<Todo> todos,
    @Default(0) int selectedCategoryIndex,
  }) = _Initial;
}
