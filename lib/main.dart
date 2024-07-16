import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task/bootstrap.dart';
import 'package:maids_task/core/dependency_injection/service_locator.dart';
import 'package:maids_task/core/helpers/secure_sharedprefernce.dart';
import 'package:maids_task/core/network/certifications.dart';
import 'package:maids_task/core/theme.dart';
import 'package:maids_task/features/todo/bloc/todo_bloc.dart';
import 'package:maids_task/features/login/cubit/login_cubit.dart';
import 'package:maids_task/features/login/presentation/screens/login_screen.dart';
import 'package:maids_task/features/login/repo/login_repo_imb.dart';
import 'package:maids_task/features/todo/bloc/todo_event.dart';
import 'package:maids_task/features/todo/repos/todo_repo_imb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  HttpOverrides.global = MyHttpOverrides();
  bootstrap(() => const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(
            loginRepo: serviceLocator<LoginRepoImb>(),
            sharedPreferencesHelper: serviceLocator<SharedPreferencesHelper>(),
          ),
        ),
        BlocProvider(
            create: (context) => TodoBloc(
                  todoRepository: serviceLocator<TodoRepoImb>(),
                )..add(LoadTodos()))
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            title: 'Maids',
            debugShowCheckedModeBanner: false,
            theme: AppTheme().appTheme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
