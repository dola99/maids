// Generate mock classes
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:maids_task/core/network/network_layer.dart';
import 'package:maids_task/features/todo/repos/todo_repo_imb.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todo_repo_test.mocks.dart';

@GenerateMocks([NetworkService])
void main() {
  late MockNetworkService mockNetworkService;
  late TodoRepoImb todoRepo;

  setUp(() {
    mockNetworkService = MockNetworkService();
    todoRepo = TodoRepoImb(networkService: mockNetworkService);
  });

  group('TodoRepoImb', () {
    final todo = Todo(
      id: 1,
      todo: 'Test Todo',
      completed: false,
      userId: 1,
    );

    test('fetchTodos returns a list of todos on success', () async {
      when(mockNetworkService.getRequest(any)).thenAnswer(
        (_) async => {
          'todos': [
            {
              'id': 1,
              'todo': 'Test Todo',
              'completed': false,
              'userId': 1,
            },
          ],
        },
      );

      final result = await todoRepo.fetchTodos();
      expect(result.isRight(), true);
      expect(result.getOrElse(() => []), isA<List<Todo>>());
      expect(result.getOrElse(() => [])[0].todo, 'Test Todo');
    });

    test('fetchTodos returns an error message on failure', () async {
      when(mockNetworkService.getRequest(any))
          .thenThrow(Exception('Network error'));

      final result = await todoRepo.fetchTodos();
      expect(result.isLeft(), true);
      expect(result.swap().getOrElse(() => ''),
          'Failed to fetch todos: Exception: Network error');
    });

    test('addTodo returns a todo on success', () async {
      when(mockNetworkService.postRequest(any, any)).thenAnswer(
        (_) async => {
          'id': 1,
          'todo': 'Test Todo',
          'completed': false,
          'userId': 1,
        },
      );

      final result = await todoRepo.addTodo(todo);
      expect(result.isRight(), true);
      expect(result.getOrElse(() => todo), isA<Todo>());
      expect(result.getOrElse(() => todo).todo, 'Test Todo');
    });

    test('addTodo returns an error message on failure', () async {
      when(mockNetworkService.postRequest(any, any))
          .thenThrow(Exception('Network error'));

      final result = await todoRepo.addTodo(todo);
      expect(result.isLeft(), true);
      expect(result.swap().getOrElse(() => ''),
          'Failed to add todo: Exception: Network error');
    });

    test('updateTodo returns an updated todo on success', () async {
      when(mockNetworkService.putRequest(any, any)).thenAnswer(
        (_) async => {
          'id': 1,
          'todo': 'Updated Todo',
          'completed': true,
          'userId': 1,
        },
      );

      final updatedTodo = todo.copyWith(todo: 'Updated Todo', completed: true);
      final result = await todoRepo.updateTodo(updatedTodo);
      expect(result.isRight(), true);
      expect(result.getOrElse(() => todo), isA<Todo>());
      expect(result.getOrElse(() => todo).todo, 'Updated Todo');
    });

    test('updateTodo returns an error message on failure', () async {
      when(mockNetworkService.putRequest(any, any))
          .thenThrow(Exception('Network error'));

      final result = await todoRepo.updateTodo(todo);
      expect(result.isLeft(), true);
      expect(result.swap().getOrElse(() => ''),
          'Failed to update todo: Exception: Network error');
    });

    // test('deleteTodo returns true on success', () async {
    //   when(mockNetworkService.deleteRequest(any))
    //       .thenAnswer((_) async => await Riit);

    //   final result = await todoRepo.deleteTodo(1);
    //   expect(result.isRight(), true);
    //   expect(result.getOrElse(() => false), true);
    // });

    test('deleteTodo returns an error message on failure', () async {
      when(mockNetworkService.deleteRequest(any))
          .thenThrow(Exception('Network error'));

      final result = await todoRepo.deleteTodo(1);
      expect(result.isLeft(), true);
      expect(result.swap().getOrElse(() => ''),
          'Failed to delete todo: Exception: Network error');
    });
  });
}
