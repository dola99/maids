import 'package:dartz/dartz.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:maids_task/core/network/network_layer.dart';

abstract class TodoRepository {
  final NetworkService networkService;

  TodoRepository({required this.networkService});

  Future<Either<String, List<Todo>>> fetchTodos({int limit = 10, int skip = 0});

  Future<Either<String, Todo>> addTodo(Todo todo);

  Future<Either<String, Todo>> updateTodo(Todo todo);

  Future<Either<String, void>> deleteTodo(int id);
}
