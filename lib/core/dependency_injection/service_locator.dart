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
