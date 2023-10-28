part of 'todo_cubit.dart';

@freezed
class TodoState with _$TodoState {
  const factory TodoState.initial({
    @Default([]) List<Todo> todos,
  }) = _Initial;
}
