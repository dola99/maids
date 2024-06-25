import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_task/features/todo/repos/todo_repo.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/bloc/todo_state.dart';

mixin UpdateTodoMixin on Bloc<TodoEvent, TodoState> {
  Future<void> onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit,
      TodoRepository todoRepository, int todosPerPage) async {
    final result = await todoRepository.updateTodo(event.todo);
    if (emit.isDone) return;
    await result.fold(
      (failure) async => emit(TodoError(failure)),
      (newTodo) async {
        event.todoList[event.index] = newTodo;
        emit(TodoLoaded(
          event.todoList,
        ));
      },
    );
  }
}
