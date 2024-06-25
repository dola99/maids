import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_task/Model/user_data.dart';
import 'package:maids_task/core/helpers/secure_sharedprefernce.dart';
import 'package:maids_task/features/login/repo/login_repo.dart';
import 'package:progress_state_button/progress_button.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  late final LoginRepo _loginRepo;
  LoginCubit({required LoginRepo loginRepo})
      : _loginRepo = loginRepo,
        super(const LoginInitial(buttonState: ButtonState.idle));

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  late UserData userData;
  Map<String, dynamic> loginCredentials = {'expiresInMins': 30};

  login() async {
    emit(const LoginLoading(buttonState: ButtonState.loading));
    try {
      final response = await _loginRepo.login(loginCredentials);
      response.fold(
          (l) => emit(
              LoginFailed(buttonState: ButtonState.fail, errorMessages: l)),
          (r) async {
        userData = r.data;
        await SharedPreferencesHelper.setToken(r.data.token);
        await SharedPreferencesHelper.init();
        inspect(userData);
        emit(LoginSuccesfully(
            buttonState: ButtonState.success, userData: r.data));
      });
    } catch (e) {
      emit(const LoginFailed(buttonState: ButtonState.fail));
    }
  }

  init() {
    emit(const LoginInitial(buttonState: ButtonState.idle));
  }
}
