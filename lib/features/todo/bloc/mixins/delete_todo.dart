import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_task/features/todo/repos/todo_repo.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/bloc/todo_state.dart';

mixin DeleteTodoMixin on Bloc<TodoEvent, TodoState> {
  Future<void> onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit,
      TodoRepository todoRepository, int todosPerPage) async {
    final result = await todoRepository.deleteTodo(event.id);
    if (emit.isDone) return;
    await result.fold(
      (failure) async => emit(TodoError(failure)),
      (_) async {
        event.todoList.removeAt(event.index);
        emit(TodoLoaded(
          event.todoList,
        ));
      },
    );
  }
}
