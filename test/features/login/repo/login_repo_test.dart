import 'package:flutter_test/flutter_test.dart';
import 'package:maids_task/features/login/repo/login_repo_imb.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:maids_task/core/network/generic_model.dart';
import 'package:maids_task/core/network/network_layer.dart';
import 'package:maids_task/Model/user_data.dart';
import 'package:dartz/dartz.dart';

import 'login_repo_test.mocks.dart';

// Generate mock classes
@GenerateMocks([NetworkService])
void main() {
  late MockNetworkService mockNetworkService;
  late LoginRepoImb loginRepoImb;

  setUp(() {
    mockNetworkService = MockNetworkService();
    loginRepoImb = LoginRepoImb(networkService: mockNetworkService);
  });

  group('LoginRepo', () {
    final loginCredentials = {'username': 'testuser', 'password': 'testpass'};

    test(
      'returns Right with GenericResponse<UserData> when login is successful',
      () async {
        when(mockNetworkService.postRequest(any, any)).thenAnswer(
          (_) async => {
            'id': 1,
            'firstName': 'John',
            'lastName': 'Doe',
            'email': 'john.doe@example.com',
            'username': 'johndoe',
            'gender': 'male',
            'image': 'https://example.com/image.jpg',
            'token': 'token123',
            'refreshToken': 'refreshToken123',
          },
        );

        var results = (await loginRepoImb.login(loginCredentials))
            .fold((failure) => failure, (response) => response);

        expect(results, isA<GenericResponse<UserData>>());

        verify(mockNetworkService.postRequest(any, loginCredentials)).called(1);
      },
    );

    test('returns Left with error message when login fails', () async {
      when(mockNetworkService.postRequest(any, any)).thenAnswer(
        (_) async => {
          'error': {'message': 'Invalid credentials'}
        },
      );

      var results = (await loginRepoImb.login(loginCredentials))
          .fold((failure) => failure, (response) => response);

      expect(results, isA<String>());

      verify(mockNetworkService.postRequest(any, loginCredentials)).called(1);
    });

    test('returns Left with error message when login fails', () async {
      when(mockNetworkService.postRequest(any, any)).thenAnswer(
        (_) async => {
          'error': {'message': 'Invalid credentials'}
        },
      );

      final Either<String, GenericResponse<UserData>> result =
          await loginRepoImb.login(loginCredentials);

      expect(result, equals(Left('Invalid credentials')));
      verify(mockNetworkService.postRequest(any, loginCredentials)).called(1);
    });
  });
}
