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
  final LoginRepo _loginRepo;
  final SharedPreferencesHelper _sharedPreferencesHelper;

  LoginCubit({
    required LoginRepo loginRepo,
    required SharedPreferencesHelper sharedPreferencesHelper,
  })  : _loginRepo = loginRepo,
        _sharedPreferencesHelper = sharedPreferencesHelper,
        super(const LoginInitial(buttonState: ButtonState.idle));

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  late UserData userData;
  final Map<String, dynamic> loginCredentials = {'expiresInMins': 30};

  Future<void> login() async {
    emit(const LoginLoading(buttonState: ButtonState.loading));
    try {
      final response = await _loginRepo.login(loginCredentials);
      response.fold(
        (failure) => emit(
          LoginFailed(buttonState: ButtonState.fail, errorMessages: failure),
        ),
        (success) async {
          userData = success.data;
          await _sharedPreferencesHelper.setToken(success.data.token);
          await _sharedPreferencesHelper.init();
          emit(LoginSuccesfully(
              buttonState: ButtonState.success, userData: success.data));
        },
      );
    } catch (error) {
      emit(const LoginFailed(buttonState: ButtonState.fail));
    }
  }

  void init() {
    emit(const LoginInitial(buttonState: ButtonState.idle));
  }
}
