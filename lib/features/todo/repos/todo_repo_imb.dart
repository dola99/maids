import 'package:dartz/dartz.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:maids_task/core/network/network_layer.dart';
import 'package:maids_task/core/network/service_urls.dart';
import 'package:maids_task/features/todo/repos/todo_repo.dart';

class TodoRepoImb extends TodoRepository {
  TodoRepoImb({required NetworkService networkService})
      : super(networkService: networkService);

  @override
  Future<Either<String, List<Todo>>> fetchTodos(
      {int limit = 10, int skip = 0}) async {
    try {
      final response = await networkService
          .getRequest('${ServicesUrl.todosApi}?limit=$limit&skip=$skip');
      final todos =
          (response['todos'] as List).map((e) => Todo.fromJson(e)).toList();
      return Right(todos);
    } catch (e) {
      return Left('Failed to fetch todos: $e');
    }
  }

  @override
  Future<Either<String, Todo>> addTodo(Todo todo) async {
    try {
      final response = await networkService.postRequest(
          ServicesUrl.addTodoApi, todo.toJson());
      return Right(Todo.fromJson(response));
    } catch (e) {
      return Left('Failed to add todo: $e');
    }
  }

  @override
  Future<Either<String, Todo>> updateTodo(Todo todo) async {
    try {
      final response = await networkService.putRequest(
          '${ServicesUrl.todosApi}/${todo.id}', todo.toJson());
      return Right(Todo.fromJson(response));
    } catch (e) {
      return Left('Failed to update todo: $e');
    }
  }

  @override
  Future<Either<String, bool>> deleteTodo(int id) async {
    try {
      await networkService.deleteRequest('${ServicesUrl.todosApi}/$id');
      return const Right(true);
    } catch (e) {
      return Left('Failed to delete todo: $e');
    }
  }
}
