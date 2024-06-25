import 'package:maids_task/Model/todo_model.dart';

abstract class TodoState {
  const TodoState();
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final bool hasReachedMax;

  const TodoLoaded(this.todos, {this.hasReachedMax = false});
}

class TodoLoadingMore extends TodoState {
  final List<Todo> todos;

  const TodoLoadingMore(this.todos);
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);
}
