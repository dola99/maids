// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:maids_task/features/todo/bloc/todo_bloc.dart';
// import 'package:mockito/mockito.dart';
// import 'package:maids_task/features/todo/bloc/todo_event.dart';
// import 'package:maids_task/features/todo/bloc/todo_state.dart';
// import 'package:maids_task/features/todo/repos/todo_repo.dart';

// class MockTodoRepository extends Mock implements TodoRepository {}

// void main() {
//   group('AddTodoMixin', () {
//     late MockTodoRepository mockTodoRepository;
//     late TodoBloc testTodoBloc;

//     setUp(() {
//       mockTodoRepository = MockTodoRepository();
//       testTodoBloc = TodoBloc(todoRepository: mockTodoRepository);
//     });

//     blocTest<TodoBloc, TodoState>(
//       'emits [TodoLoaded] when AddTodo is added successfully',
//       build: () {
//         when(mockTodoRepository.addTodo()).thenAnswer(
//           (_) async => Right(
//               MockTodo()), // Adjust this to match your actual Todo model and response
//         );
//         return testTodoBloc;
//       },
//       act: (bloc) => bloc.add(AddTodo(
//         todo: MockTodo(), // Adjust this to match your actual AddTodo event
//         todoList: [],
//       )),
//       expect: () => [
//         isA<TodoLoaded>(),
//       ],
//     );

//     blocTest<TestTodoBloc, TodoState>(
//       'emits [TodoError] when AddTodo fails',
//       build: () {
//         when(mockTodoRepository.addTodo(any)).thenAnswer(
//           (_) async => Left(
//               MockFailure()), // Adjust this to match your actual Failure model and response
//         );
//         return testTodoBloc;
//       },
//       act: (bloc) => bloc.add(AddTodo(
//         todo: MockTodo(), // Adjust this to match your actual AddTodo event
//         todoList: [],
//       )),
//       expect: () => [
//         isA<TodoError>(),
//       ],
//     );
//   });
// }
