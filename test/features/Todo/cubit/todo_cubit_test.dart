import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:mockito/mockito.dart';
import 'package:maids_task/features/todo/bloc/todo_bloc.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/bloc/todo_state.dart';
import 'package:maids_task/features/todo/repos/todo_repo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('TodoBloc', () {
    late MockTodoRepository mockTodoRepository;
    late TodoBloc todoBloc;

    setUp(() {
      mockTodoRepository = MockTodoRepository();
      todoBloc = TodoBloc(todoRepository: mockTodoRepository);
    });

    tearDown(() {
      todoBloc.close();
    });

    final todo = Todo(
      todo: 'Hello',
      completed: true,
      userId: 12,
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when LoadTodos is added',
      build: () {
        when(mockTodoRepository.fetchTodos()).thenAnswer(
          (_) async => const Right(<Todo>[]),
        );
        return todoBloc;
      },
      act: (bloc) => bloc.add(LoadTodos()),
      expect: () => [
        TodoLoading(),
        isA<TodoLoaded>(),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoError] when LoadTodos fails',
      build: () {
        when(mockTodoRepository.fetchTodos()).thenAnswer(
          (_) async => Left('Failure'),
        );
        return todoBloc;
      },
      act: (bloc) => bloc.add(LoadTodos()),
      expect: () => [
        TodoLoading(),
        isA<TodoError>(),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoadingMore, TodoLoaded] when LoadMoreTodos is added',
      build: () {
        when(mockTodoRepository.fetchTodos()).thenAnswer(
          (_) async => Right(<Todo>[]),
        );
        todoBloc.emit(TodoLoaded(<Todo>[], hasReachedMax: false));
        return todoBloc;
      },
      act: (bloc) => bloc.add(LoadMoreTodos(10)),
      expect: () => [
        TodoLoadingMore(<Todo>[]),
        isA<TodoLoaded>(),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoaded] when AddTodo is successful',
      build: () {
        when(mockTodoRepository.addTodo(
          todo,
        )).thenAnswer(
          (_) async => Right(todo),
        );
        return todoBloc;
      },
      act: (bloc) => bloc.add(AddTodo(todo, [])),
      expect: () => [
        isA<TodoLoaded>(),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoError] when AddTodo fails',
      build: () {
        when(mockTodoRepository
                .addTodo(Todo(todo: 'todo', completed: true, userId: 11)))
            .thenAnswer(
          (_) async => Left('Failure'),
        );
        return todoBloc;
      },
      act: (bloc) => bloc.add(AddTodo(todo, [])),
      expect: () => [
        isA<TodoError>(),
      ],
    );

    // Repeat similar tests for DeleteTodo and UpdateTodo events
  });
}
