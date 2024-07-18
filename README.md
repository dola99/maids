
# Project Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Project Setup](#project-setup)
3. [Dependencies](#dependencies)
4. [Service Locator Setup](#service-locator-setup)
5. [Cubit and Bloc](#cubit-and-bloc)
   - [LoginCubit](#logincubit)
   - [TodoBloc](#todobloc)
   - [Using Mixins in Bloc](#using-mixins-in-bloc)
6. [Running the Project](#running-the-project)
7. [Testing](#testing)
   - [LoginCubit Testing](#logincubit-testing)
   - [TodoBloc Testing](#todobloc-testing)
8. [Credentials](#credentials)

## Introduction

This document provides guidelines for setting up and testing the `LoginCubit` and `TodoBloc` in a Flutter project using the Bloc pattern, `GetIt` for dependency injection, and `mockito` for mocking dependencies. This is designed for a senior Flutter developer position.

## Project Setup

Clone the repository and navigate to the project directory:

```bash
git clone <repository-url>
cd <project-directory>
```

Install the dependencies:

```bash
flutter pub get
```

## Dependencies

### Why Use These Dependencies:

1. **`flutter_bloc`**: For state management using the Bloc pattern.
2. **`equatable`**: To make Dart objects comparable, useful for comparing Bloc states.
3. **`get_it`**: A service locator for dependency injection.
4. **`http`**: For making HTTP requests in the `NetworkService`.
5. **`dartz`**: Provides functional programming tools for Dart.

### Development Dependencies:

1. **`flutter_test`**: The testing framework for Flutter applications.
2. **`mockito`**: For creating mock objects in unit tests.
3. **`build_runner`**: For generating mock classes with `mockito`.

## Service Locator Setup

### Why Use a Service Locator:

- **Centralized Dependency Management**: Manage all dependencies from a single place.
- **Lazy Initialization**: Instances are created only when requested, improving startup time and resource usage.
- **Separation of Concerns**: Decouples dependency creation from business logic, leading to cleaner code.

### Service Locator Configuration:

```dart
import 'package:get_it/get_it.dart';
import 'package:maids_task/core/helpers/secure_sharedprefernce.dart';
import 'package:maids_task/core/network/network_layer.dart';
import 'package:maids_task/core/network/service_urls.dart';
import 'package:maids_task/features/todo/repos/todo_repo_imb.dart';
import 'package:maids_task/features/login/repo/login_repo_imb.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton(
      () => NetworkService(baseUrl: ServicesUrl.baseUrl));
  serviceLocator.registerLazySingleton(() => SharedPreferencesHelper()..init());

  serviceLocator.registerLazySingleton(
      () => LoginRepoImb(networkService: serviceLocator<NetworkService>()));
  serviceLocator.registerLazySingleton(
      () => TodoRepoImb(networkService: serviceLocator<NetworkService>()));
}
```

## Cubit and Bloc

### LoginCubit

The `LoginCubit` handles the login logic, managing states like loading, success, and failure.

### TodoBloc

The `TodoBloc` handles various actions related to todos, such as adding, deleting, updating, and loading todos. It uses mixins to separate the logic for each action.

### Using Mixins in Bloc

### Why Use Mixins to Separate Complex Logic:

- **Modularity**: Mixins allow you to split complex logic into smaller, more manageable pieces. Each mixin can encapsulate related functionality, making the code more modular.
- **Reusability**: Mixins promote code reusability. By separating logic into mixins, you can easily reuse the same mixin in different Blocs or even in different projects.
- **Maintainability**: Separating logic into mixins makes the code easier to maintain. Each mixin has a single responsibility, adhering to the Single Responsibility Principle (SRP), which simplifies debugging and enhances readability.
- **Testability**: Isolating logic into mixins makes unit testing more straightforward. You can test each mixin independently, ensuring that the individual pieces of logic work correctly before integrating them into the Bloc.

Example Mixins:

#### AddTodoMixin

```dart
mixin AddTodoMixin on Bloc<TodoEvent, TodoState> {
  Future<void> onAddTodo(AddTodo event, Emitter<TodoState> emit,
      TodoRepository todoRepository, int todosPerPage) async {
    final result = await todoRepository.addTodo(event.todo);
    if (emit.isDone) return;
    await result.fold(
      (failure) async => emit(TodoError(failure)),
      (newTodo) async {
        event.todoList.insert(0, newTodo);
        emit(TodoLoaded(
          event.todoList,
        ));
      },
    );
  }
}
```

#### DeleteTodoMixin

```dart
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
```

#### UpdateTodoMixin

```dart
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
```

## Running the Project

To run the project, ensure you have a Flutter development environment set up. Then, execute:

```bash
flutter run
```

## Testing

### Why Test:

- **Ensure Correct State Transitions**: Verify that the Cubit and Bloc emit the correct states.
- **Verify Business Logic**: Ensure the business logic works as expected.
- **Mock Dependencies**: Use `mockito` to mock dependencies and test the Cubit and Bloc in isolation.

### Generating Mocks:

Generate mock classes using `build_runner`:

```bash
flutter pub run build_runner build
```

### LoginCubit Testing

Create a test file named `login_cubit_test.dart` and write tests to ensure the `LoginCubit` emits the correct states.

### TodoBloc Testing

Create a test file named `todo_bloc_test.dart` and write tests to ensure the `TodoBloc` handles events correctly and emits the expected states.

### Running Tests

To run the tests, use the following command:

```bash
flutter test
```

## Credentials

To log in to the application, use the following credentials:

- **Username**: `emilys`
- **Password**: `emilyspass`

