import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_task/Model/todo_model.dart';
import 'package:maids_task/Model/user_data.dart';
import 'package:maids_task/core/constant.dart';
import 'package:maids_task/core/helpers/custom_textfield_params.dart';
import 'package:maids_task/features/todo/bloc/todo_bloc.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/bloc/todo_state.dart';
import 'package:maids_task/features/todo/presentation/componets/todo_appbar.dart';
import 'package:maids_task/widgets/custom_textformfield.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoListScreenAppbar(),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded || state is TodoLoadingMore) {
            final todos = state is TodoLoaded
                ? state.todos
                : (state as TodoLoadingMore).todos;
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels ==
                        scrollNotification.metrics.maxScrollExtent &&
                    state is! TodoLoadingMore) {
                  context.read<TodoBloc>().add(LoadMoreTodos(todos.length));
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemCount: todos.length + (state is TodoLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == todos.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo.todo),
                    leading: Checkbox(
                      value: todo.completed,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        context.read<TodoBloc>().add(UpdateTodo(
                            todo.copyWith(completed: value!), index, todos));
                      },
                    ),
                    trailing: IconButton(
                      icon:
                          Icon(Icons.delete, color: Colors.red.withOpacity(.8)),
                      onPressed: () {
                        context
                            .read<TodoBloc>()
                            .add(DeleteTodo(todo.id!, index, todos));
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final todoController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add New Todo'),
                content: CustomTextFormField(
                  params: CustomTextFormFieldParams(controller: todoController

                      // onFieldSubmitted: (va) {
                      //   _passwordFocusNode.requestFocus();
                      // },
                      // validator: (value) {
                      //   return ValidatorHelper.validateUserName(value);
                      // },
                      // onSaved: (value) {
                      //   LoginCubit.get(context).loginCredentials['username'] =
                      //       value;
                      // },
                      ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final newTodo = Todo(
                        userId: UserData.getInstance().id,
                        id: DateTime.now().millisecondsSinceEpoch,
                        todo: todoController.text,
                        completed: false,
                      );
                      context.read<TodoBloc>().add(AddTodo(
                          newTodo,
                          (context.read<TodoBloc>().state as TodoLoaded)
                              .todos));
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
