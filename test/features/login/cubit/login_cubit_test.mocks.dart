// Mocks generated by Mockito 5.4.4 from annotations
// in maids_task/test/features/login/cubit/login_cubit_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:maids_task/core/helpers/secure_sharedprefernce.dart' as _i8;
import 'package:maids_task/core/network/generic_model.dart' as _i6;
import 'package:maids_task/core/network/network_layer.dart' as _i2;
import 'package:maids_task/features/login/repo/login_repo.dart' as _i4;
import 'package:maids_task/Model/user_data.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:shared_preferences/shared_preferences.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeNetworkService_0 extends _i1.SmartFake
    implements _i2.NetworkService {
  _FakeNetworkService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LoginRepo].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginRepo extends _i1.Mock implements _i4.LoginRepo {
  MockLoginRepo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.NetworkService get networkService => (super.noSuchMethod(
        Invocation.getter(#networkService),
        returnValue: _FakeNetworkService_0(
          this,
          Invocation.getter(#networkService),
        ),
      ) as _i2.NetworkService);

  @override
  _i5.Future<_i3.Either<String, _i6.GenericResponse<_i7.UserData>>> login(
          Map<String, dynamic>? logincredentials) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [logincredentials],
        ),
        returnValue: _i5.Future<
                _i3.Either<String, _i6.GenericResponse<_i7.UserData>>>.value(
            _FakeEither_1<String, _i6.GenericResponse<_i7.UserData>>(
          this,
          Invocation.method(
            #login,
            [logincredentials],
          ),
        )),
      ) as _i5.Future<_i3.Either<String, _i6.GenericResponse<_i7.UserData>>>);
}

/// A class which mocks [SharedPreferencesHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferencesHelper extends _i1.Mock
    implements _i8.SharedPreferencesHelper {
  MockSharedPreferencesHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> init({_i9.SharedPreferences? sharedPreferences}) =>
      (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
          {#sharedPreferences: sharedPreferences},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<bool> setToken(String? token) => (super.noSuchMethod(
        Invocation.method(
          #setToken,
          [token],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<String?> getToken() => (super.noSuchMethod(
        Invocation.method(
          #getToken,
          [],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<void> clearToken() => (super.noSuchMethod(
        Invocation.method(
          #clearToken,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
