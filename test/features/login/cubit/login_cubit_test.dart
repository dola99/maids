import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maids_task/core/network/generic_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:maids_task/Model/user_data.dart';
import 'package:maids_task/features/login/cubit/login_cubit.dart';
import 'package:maids_task/features/login/repo/login_repo.dart';
import 'package:progress_state_button/progress_button.dart';

// Generate a MockLoginRepo
@GenerateMocks([LoginRepo])
import 'login_cubit_test.mocks.dart';

void main() {
  late MockLoginRepo mockLoginRepo;
  late LoginCubit loginCubit;

  setUp(() {
    mockLoginRepo = MockLoginRepo();
    loginCubit = LoginCubit(loginRepo: mockLoginRepo);
  });

  group('LoginCubit', () {
    final userData = UserData.fromJson({
      'id': 1,
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@example.com',
      'username': 'johndoe',
      'gender': 'male',
      'image': 'https://example.com/image.jpg',
      'token': 'token123',
      'refreshToken': 'refreshToken123',
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccesfully] when login is successful',
      build: () {
        when(mockLoginRepo.login(any))
            .thenAnswer((_) async => Right(GenericResponse(data: userData)));
        return loginCubit;
      },
      act: (cubit) => cubit.login(),
      expect: () => [
        const LoginLoading(buttonState: ButtonState.loading),
        LoginSuccesfully(buttonState: ButtonState.success, userData: userData),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginFailed] when login fails',
      build: () {
        when(mockLoginRepo.login(any))
            .thenAnswer((_) async => Left('Login Failed'));
        return loginCubit;
      },
      act: (cubit) => cubit.login(),
      expect: () => [
        const LoginLoading(buttonState: ButtonState.loading),
        const LoginFailed(
            buttonState: ButtonState.fail, errorMessages: 'Login Failed'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginFailed] when an exception is thrown',
      build: () {
        when(mockLoginRepo.login(any)).thenThrow(Exception('Exception thrown'));
        return loginCubit;
      },
      act: (cubit) => cubit.login(),
      expect: () => [
        const LoginLoading(buttonState: ButtonState.loading),
        const LoginFailed(buttonState: ButtonState.fail),
      ],
    );
  });
}
