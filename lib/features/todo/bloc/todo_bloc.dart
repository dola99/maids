import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_task/features/todo/repos/todo_repo.dart';
import 'package:maids_task/features/Todo/bloc/mixins/add_todo.dart';
import 'package:maids_task/features/Todo/bloc/mixins/delete_todo.dart';
import 'package:maids_task/features/Todo/bloc/mixins/update_todo.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>
    with AddTodoMixin, DeleteTodoMixin, UpdateTodoMixin {
  final TodoRepository todoRepository;
  static const int todosPerPage = 10;

  TodoBloc({required this.todoRepository}) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<LoadMoreTodos>(_onLoadMoreTodos);
    on<AddTodo>((event, emit) async =>
        await onAddTodo(event, emit, todoRepository, todosPerPage));
    on<DeleteTodo>((event, emit) async =>
        await onDeleteTodo(event, emit, todoRepository, todosPerPage));
    on<UpdateTodo>((event, emit) async =>
        await onUpdateTodo(event, emit, todoRepository, todosPerPage));
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    final result = await todoRepository.fetchTodos(limit: todosPerPage);
    if (emit.isDone) return;
    await result.fold(
      (failure) async => emit(TodoError(failure)),
      (todos) async =>
          emit(TodoLoaded(todos, hasReachedMax: todos.length < todosPerPage)),
    );
  }

  Future<void> _onLoadMoreTodos(
      LoadMoreTodos event, Emitter<TodoState> emit) async {
    final currentState = state;
    if (currentState is TodoLoaded && !currentState.hasReachedMax) {
      emit(TodoLoadingMore(currentState.todos));
      final result = await todoRepository.fetchTodos(
          limit: todosPerPage, skip: event.skip);
      if (emit.isDone) return;
      await result.fold(
        (failure) async => emit(TodoError(failure)),
        (newTodos) async {
          final todos = currentState.todos + newTodos;
          emit(TodoLoaded(todos, hasReachedMax: newTodos.isEmpty));
        },
      );
    }
  }
}
