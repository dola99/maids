import 'package:flutter_test/flutter_test.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:maids_task/core/network/network_layer.dart';
import 'package:maids_task/features/todo/repos/todo_repo_imb.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../login/repo/login_repo_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  late MockNetworkService mockNetworkService;
  late TodoRepoImb todoRepoImb;

  setUp(() {
    mockNetworkService = MockNetworkService();
    todoRepoImb = TodoRepoImb(networkService: mockNetworkService);
  });

  group('fetchTodos', () {
    test('should return a list of todos when the network call is successful',
        () async {
      // Arrange
      final mockTodos = [
        Todo(todo: 'Test Todo 1', completed: false, userId: 1),
        Todo(todo: 'Test Todo 2', completed: true, userId: 2),
      ];
      final response = {
        'todos': mockTodos.map((todo) => todo.toJson()).toList(),
      };
      when(mockNetworkService.getRequest(any))
          .thenAnswer((_) async => response);

      // Act
      final result = await todoRepoImb.fetchTodos();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => null,
        (r) => expect(r, mockTodos),
      );
    });

    test('should return an error message when the network call fails',
        () async {
      // Arrange
      when(mockNetworkService.getRequest(any))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await todoRepoImb.fetchTodos();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, 'Failed to fetch todos: Exception: Network error'),
        (r) => null,
      );
    });
  });

  group('addTodo', () {
    test('should return the added todo when the network call is successful',
        () async {
      // Arrange
      final mockTodo = Todo(todo: 'Test Todo 1', completed: false, userId: 1);
      when(mockNetworkService.postRequest(any, any))
          .thenAnswer((_) async => mockTodo.toJson());

      // Act
      final result = await todoRepoImb.addTodo(mockTodo);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => null,
        (r) => expect(r, mockTodo),
      );
    });

    test('should return an error message when the network call fails',
        () async {
      // Arrange
      final mockTodo =
          Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1);
      when(mockNetworkService.postRequest(any, any))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await todoRepoImb.addTodo(mockTodo);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, 'Failed to add todo: Exception: Network error'),
        (r) => null,
      );
    });
  });

  group('updateTodo', () {
    test('should return the updated todo when the network call is successful',
        () async {
      // Arrange
      final mockTodo = Todo(todo: 'Test Todo 1', completed: false, userId: 1);
      when(mockNetworkService.putRequest(any, any))
          .thenAnswer((_) async => mockTodo.toJson());

      // Act
      final result = await todoRepoImb.updateTodo(mockTodo);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => null,
        (r) => expect(r, mockTodo),
      );
    });

    test('should return an error message when the network call fails',
        () async {
      // Arrange
      final mockTodo =
          Todo(id: 1, todo: 'Test Todo 1', completed: false, userId: 1);
      when(mockNetworkService.putRequest(any, any))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await todoRepoImb.updateTodo(mockTodo);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, 'Failed to update todo: Exception: Network error'),
        (r) => null,
      );
    });
  });

  group('deleteTodo', () {
    test('should return true when the network call is successful', () async {
      // Arrange
      when(mockNetworkService.deleteRequest(any))
          .thenAnswer((_) async => <String, dynamic>{});

      // Act
      final result = await todoRepoImb.deleteTodo(1);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => null,
        (r) => expect(r, true),
      );
    });

    test('should return an error message when the network call fails',
        () async {
      // Arrange
      when(mockNetworkService.deleteRequest(any))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await todoRepoImb.deleteTodo(1);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l, 'Failed to delete todo: Exception: Network error'),
        (r) => null,
      );
    });
  });
}
