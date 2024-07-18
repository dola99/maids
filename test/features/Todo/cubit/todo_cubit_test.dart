import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:maids_task/features/todo/bloc/todo_bloc.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/bloc/todo_state.dart';
import 'package:maids_task/features/todo/repos/todo_repo.dart';

import 'todo_cubit_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockTodoRepository;
  late TodoBloc todoBloc;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    todoBloc = TodoBloc(todoRepository: mockTodoRepository);
  });

  tearDown(() {
    todoBloc.close();
  });

  group('TodoBloc', () {
    test('should emit TodoError when addTodo fails', () async {
      // Arrange
      final testTodo = Todo(
        id: 1,
        todo: 'Test Todo',
        userId: 1,
        completed: false,
      );
      final testTodoList = <Todo>[];
      when(mockTodoRepository.addTodo(any))
          .thenAnswer((_) async => const Left('Failed to add todo'));

      // Act
      todoBloc.add(AddTodo(testTodo, testTodoList));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>()
              .having((e) => e.message, 'message', 'Failed to add todo'),
        ]),
      );
    });

    test('should emit TodoLoaded when addTodo is successful', () async {
      // Arrange
      final testTodo = Todo(
        id: 1,
        todo: 'Test Todo',
        userId: 1,
        completed: false,
      );
      final testTodoList = <Todo>[];
      when(mockTodoRepository.addTodo(any))
          .thenAnswer((_) async => Right(testTodo));

      // Act
      todoBloc.add(AddTodo(testTodo, testTodoList));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((s) => s.todos, 'todos', contains(testTodo)),
        ]),
      );
    });

    test('should emit TodoError when deleteTodo fails', () async {
      // Arrange
      when(mockTodoRepository.deleteTodo(any))
          .thenAnswer((_) async => const Left('Failed to delete todo'));

      // Act
      todoBloc.add(DeleteTodo(1, 0, []));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>()
              .having((e) => e.message, 'message', 'Failed to delete todo'),
        ]),
      );
    });

    test('should emit TodoLoaded when deleteTodo is successful', () async {
      // Arrange
      final testTodoList = <Todo>[
        Todo(
          id: 1,
          todo: 'Test Todo',
          userId: 1,
          completed: false,
        ),
      ];
      when(mockTodoRepository.deleteTodo(any))
          .thenAnswer((_) async => const Right(true));

      // Act
      todoBloc.add(DeleteTodo(1, 0, testTodoList));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((s) => s.todos, 'todos', isEmpty),
        ]),
      );
    });

    test('should emit TodoError when updateTodo fails', () async {
      // Arrange
      final testTodo = Todo(
        id: 1,
        todo: 'Updated Todo',
        userId: 1,
        completed: false,
      );
      final testTodoList = <Todo>[testTodo];
      when(mockTodoRepository.updateTodo(any))
          .thenAnswer((_) async => const Left('Failed to update todo'));

      // Act
      todoBloc.add(UpdateTodo(testTodo, 0, testTodoList));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoError>()
              .having((e) => e.message, 'message', 'Failed to update todo'),
        ]),
      );
    });

    test('should emit TodoLoaded when updateTodo is successful', () async {
      // Arrange
      final testTodo = Todo(
        id: 1,
        todo: 'Updated Todo',
        userId: 1,
        completed: false,
      );
      final testTodoList = <Todo>[testTodo];
      when(mockTodoRepository.updateTodo(any))
          .thenAnswer((_) async => Right(testTodo));

      // Act
      todoBloc.add(UpdateTodo(testTodo, 0, testTodoList));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoaded>().having((s) => s.todos, 'todos', contains(testTodo)),
        ]),
      );
    });

    test('should emit TodoLoading and TodoLoaded when loadTodos is successful',
        () async {
      // Arrange
      final testTodos = [
        Todo(
          id: 1,
          todo: 'Test Todo 1',
          userId: 1,
          completed: false,
        ),
        Todo(
          id: 2,
          todo: 'Test Todo 2',
          userId: 1,
          completed: true,
        ),
      ];
      when(mockTodoRepository.fetchTodos(limit: anyNamed('limit')))
          .thenAnswer((_) async => Right(testTodos));

      // Act
      todoBloc.add(LoadTodos());

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoading>(),
          isA<TodoLoaded>().having((s) => s.todos, 'todos', testTodos),
        ]),
      );
    });

    test(
        'should emit TodoLoadingMore and TodoLoaded when loadMoreTodos is successful',
        () async {
      // Arrange
      final initialTodos = [
        Todo(
          id: 1,
          todo: 'Test Todo 1',
          userId: 1,
          completed: false,
        ),
      ];
      final newTodos = [
        Todo(
          id: 2,
          todo: 'Test Todo 2',
          userId: 1,
          completed: true,
        ),
      ];
      when(mockTodoRepository.fetchTodos(
              limit: anyNamed('limit'), skip: anyNamed('skip')))
          .thenAnswer((_) async => Right(newTodos));

      // Emit initial loaded state
      todoBloc.emit(TodoLoaded(initialTodos, hasReachedMax: false));

      // Act
      todoBloc.add(LoadMoreTodos(1));

      // Assert
      await expectLater(
        todoBloc.stream,
        emitsInOrder([
          isA<TodoLoadingMore>().having((s) => s.todos, 'todos', initialTodos),
          isA<TodoLoaded>()
              .having((s) => s.todos, 'todos', initialTodos + newTodos),
        ]),
      );
    });
  });
}
