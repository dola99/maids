import 'dart:developer';

import 'package:maids_task/Model/user_data.dart';
import 'package:maids_task/core/network/generic_model.dart';
import 'package:maids_task/core/network/network_layer.dart';
import 'package:maids_task/core/network/service_urls.dart';
import 'package:maids_task/features/login/repo/login_repo.dart';
import 'package:dartz/dartz.dart';

class LoginRepoImb extends LoginRepo {
  LoginRepoImb({required NetworkService networkService})
      : super(networkService: networkService);

  @override
  Future<Either<String, GenericResponse<UserData>>> login(
      Map<String, dynamic> logincredentials) async {
    final response = await networkService.postRequest(
        ServicesUrl.loginApi, logincredentials);
    inspect(response);
    if (response['error'] != null) {
      return Left(response['error']['message']);
    } else {
      return Right(GenericResponse<UserData>.fromJson(
          response, (map) => UserData.fromJson(map)));
    }
    // return Response<String>.fromJson(
    //   jsonResponse,
    //   (itemJson) => MerchantItem.fromJson(itemJson),
    // );
  }
}
