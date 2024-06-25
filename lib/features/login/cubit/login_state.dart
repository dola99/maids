part of 'login_cubit.dart';

@immutable
sealed class LoginState extends Equatable {
  final ButtonState buttonState;
  const LoginState({required this.buttonState});
}

final class LoginInitial extends LoginState {
  const LoginInitial({required super.buttonState});

  @override
  List<Object?> get props => [];
}

final class LoginLoading extends LoginState {
  const LoginLoading({required super.buttonState});

  @override
  List<Object?> get props => [];
}

final class LoginSuccesfully extends LoginState {
  final UserData? userData;
  const LoginSuccesfully({required super.buttonState, this.userData});

  @override
  List<Object?> get props => [userData];
}

final class LoginFailed extends LoginState {
  final String? errorMessages;
  const LoginFailed({required super.buttonState, this.errorMessages});

  @override
  List<Object?> get props => [errorMessages];
}
