import 'package:equatable/equatable.dart';
import 'package:maids_task/Model/todo_model.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class LoadMoreTodos extends TodoEvent {
  final int skip;

  const LoadMoreTodos(this.skip);

  @override
  List<Object> get props => [skip];
}

class AddTodo extends TodoEvent {
  final Todo todo;
  final List<Todo> todoList;
  const AddTodo(this.todo, this.todoList);

  @override
  List<Object> get props => [todo];
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  final int index;
  final List<Todo> todoList;
  const UpdateTodo(this.todo, this.index, this.todoList);

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final int id;
  final int index;
  final List<Todo> todoList;
  const DeleteTodo(this.id, this.index, this.todoList);

  @override
  List<Object> get props => [id];
}
