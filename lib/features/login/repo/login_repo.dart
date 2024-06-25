import 'package:dartz/dartz.dart';
import 'package:maids_task/Model/user_data.dart';
import 'package:maids_task/core/network/generic_model.dart';
import 'package:maids_task/core/network/network_layer.dart';

abstract class LoginRepo {
  final NetworkService networkService;
  LoginRepo({required this.networkService});

  Future<Either<String, GenericResponse<UserData>>> login(
      Map<String, dynamic> logincredentials);
}
