import 'dart:async';

import 'package:agradiance_flutter_drive/src/auth/models/token_model.dart';
import 'package:agradiance_flutter_drive/src/auth/utils/token_utils.dart';
import 'package:agradiance_flutter_drive/src/services/app_secure_storage.dart';
import 'package:agradiance_flutter_drive/src/typesdef/typedefs.dart';
import 'package:agradiance_flutter_drive/src/typesdef/xfiledata.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc({AuthState? state, required this.authMode}) : super(state ?? AuthState(authMode: authMode)) {
    //
  }

  final AuthMode authMode;

  static AuthBloc of(BuildContext context) {
    return context.read<AuthBloc>();
  }

  AuthUser? get activeUser => state.activeUser;
  AuthUser? get user => activeUser;

  bool get isAuthenticated => activeUser != null;

  Future<void> refresh() {
    return initialLoadFromStorage();
  }

  int get totalAccount => state.totalAccount;

  bool get hasMultipleAccount => totalAccount > 1;

  Future<void> initialLoadFromStorage() async {
    final loadedState = AuthState(authMode: authMode, multiUserAccount: await MultiUserAccount.loadFromStorage());

    emit(loadedState.copyWith());
  }

  Future<(bool, String)> fetchUserProfile({
    required ResultFuture<Map<String, dynamic>> Function({StringMap data}) callback,
    String? userId,
  }) async {
    // emit(state.copyWith(stateStatus: AuthStateStatus.updatingProfile));

    String errorMessage = "";

    try {
      final result = await callback(data: {"userId": userId ?? activeUser?.id});

      return await result.fold(
        (left) async {
          //dprint([left.message, StackTrace.current]);
          // emit(state.copyWith(stateStatus: AuthStateStatus.none));
          return (false, left.message);
        },
        (map) async {
          final message = map['message'];

          final data = map["data"];

          final userData = AuthUser.fromMap(data["user"]);
          await updateUserProfileAccount(newUser: userData);
          return (true, "$message");
        },
      );
    } catch (e) {
      //dprint(e);
      errorMessage = e.toString();
      // emit(state.copyWith(stateStatus: AuthStateStatus.none));
      return (false, errorMessage);
    }
  }

  Future<(bool, String)> updateUserProfile({
    String? lastName,
    String? firstName,
    String? otherName,
    String? gender,

    String? phoneCode,
    String? phoneNumber,

    XFileData? photoFile,
    required ResultFuture<Map<String, dynamic>> Function({StringMap data}) callback,
  }) async {
    // emit(state.copyWith(stateStatus: AuthStateStatus.updatingProfile));
    final data = {
      if (lastName != null) "lastName": lastName,
      if (firstName != null) "firstName": firstName,
      if (otherName != null) "otherName": otherName,
      if (phoneCode != null) "phoneCode": phoneCode,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (gender != null) "gender": gender,
      if (photoFile != null) "photo": photoFile,
    };
    //dprint(data);

    try {
      // return false;
      if (data.isEmpty) {
        return (false, "Nothing to updata");
      }
      final result = await callback(data: data);

      return await result.fold(
        (left) async {
          //dprint([left.message, StackTrace.current]);

          return (false, left.message);
        },
        (map) async {
          final message = map['message'].toString();
          final data = map["data"];

          final userData = AuthUser.fromMap(data["user"]);

          await addAccount(newUser: userData);
          return (true, message);
        },
      );
    } catch (e) {
      //dprint(e);

      // emit(state.copyWith(stateStatus: AuthStateStatus.none));
      return (false, e.toString());
    }
  }

  Future<bool> refreshUserFromDatabase(
    AuthUser? user, {
    required Future<(bool, String)> Function({String userId}) callback,
  }) async {
    if (user?.id != null) {
      final result = await callback(userId: user!.id);
      return result.$1;
    }
    return false;
  }

  AuthState get model => state;
  final secureStorage = AppSecureStorage.instance;

  Future<(bool, String)> signInUsernamePassword({
    required ResultFuture<Map<String, dynamic>> Function({StringMap data}) callback,
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(stateStatus: AuthStateStatus.signingIn));

    try {
      final result = await callback(data: {"username": username, "password": password});

      return await result.fold(
        (left) async {
          //dprint([left.message, StackTrace.current]);

          return (false, left.message);
        },
        (map) async {
          final message = map['message'].toString();
          final data = map["data"];
          final accessToken = data['accessToken'] as String?;
          final refreshToken = data['refreshToken'] as String?;
          // final accessToken = map['token'] as String?;

          //dprint(map);
          final userModel = AuthUser.fromJson(data);
          final userID = userModel.id;
          // //dprint(TokenModel.decodePayload(token: accessToken ?? ""));
          // //dprint(TokenModel.decodePayload(token: refreshToken ?? "").runtimeType);

          // return (!true, message);

          if (accessToken != null && refreshToken != null) {
            await AppSecureStorage().writeUserValue(
              userID: userID,
              ref: TokenModel.tokenValueRefKey,
              value: accessToken,
            );

            final tokenModel = TokenModel(
              userID: userID,
              accessToken: accessToken,
              refreshToken: refreshToken,
              updatedAt: DateTime.now(),
            );

            //dprint(tokenModel);

            await addAccount(newUser: userModel);
            await TokenUtils.saveUserTokenModelToStorage(tokenModel: tokenModel);

            return (true, message);
          } else {
            throw Exception("invalid userId or tokens");
          }
        },
      );
    } on Exception catch (e) {
      //dprint(e.toString());
      return (false, e.toString());
    }
  }

  Future<(bool, String)> passwordReset({
    required ResultFuture<Map<String, dynamic>> Function({StringMap data}) callback,
    required String email,
  }) async {
    emit(state.copyWith(stateStatus: AuthStateStatus.passwordResetting));

    try {
      final result = await callback(data: {"email": email});
      return await result.fold(
        (l) async {
          return (false, l.message);
        },
        (r) async {
          return (true, r["message"].toString());
        },
      );
    } catch (e) {
      return (false, e.toString());
    } finally {
      emit(state.copyWith(stateStatus: AuthStateStatus.none));
    }
  }

  Future<(bool, String)> signUp({
    required ResultFuture<Map<String, dynamic>> Function({StringMap data}) callback,
    required String username,
    required String surname,
    required String firstName,
    String? otherName,
    String? gender,
    required String email,
    required String phoneCode,
    required String phoneNumber,
    required String password,
    XFileData? photoFile,
  }) async {
    emit(state.copyWith(stateStatus: AuthStateStatus.signingUp));

    final data = {
      "username": username,
      "lastName": surname,
      "firstName": firstName,
      "email": email,
      "phoneCode": phoneCode,
      "phoneNumber": phoneNumber,
      if (gender != null) "gender": gender,
      if (otherName != null) "otherName": otherName,
      "photo": photoFile,
      "password": password,
    };

    // return false;

    try {
      final result = await callback(data: data);
      return await result.fold(
        (left) async {
          //dprint([left.message, StackTrace.current]);

          return (false, left.message);
        },
        (map) async {
          final message = map['message'];

          return (true, message.toString());
        },
      );
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<void> switchAccout({required String userID}) async {
    if ((state.userModels?.containsKey(userID) ?? false) && state.activeUserID != userID) {
      emit(
        AuthState(
          authMode: authMode,
          multiUserAccount: await state.multiUserAccount.switchAccountAndSaveAccountID(
            newCurrentSignedInUserID: userID,
          ),
        ),
      );
      // await MultiUserAccount.saveActiveUserID(id: userID);
    }
  }

  Future<void> addAccount({required AuthUser newUser}) async {
    final id = newUser.id;
    if ({if (state.userModels != null) ...state.userModels!}.containsKey(id)) {
      return updateUserProfileAccount(newUser: newUser);
    }

    Map<String, AuthUser> models = {};

    if (state.authMode.isSingle) {
      //
      state.userModels?.entries
          .whereNot((element) {
            return element.key == id;
          })
          .forEach((element) {
            try {
              signOut(signOutID: element.key);
            } catch (e) {
              //
            }
          });

      models = {};
    } else {
      //
      models = {if (state.userModels != null) ...state.userModels!};
    }

    models[id] = newUser;

    final currentID = state.activeUserID ?? id;

    await MultiUserAccount.saveStorageUserModel(resultModels: models, activeUserID: currentID);
    emit(
      AuthState(
        authMode: authMode,
        multiUserAccount: MultiUserAccount(
          userModels: models,
          activeSignedInUserID: state.activeUserID ?? newUser.id,
          //
        ),
      ),
    );

    if (models.length == 1) {
      await switchAccout(userID: id);
    }
  }

  Future<void> updateUserProfileAccount({required AuthUser newUser}) async {
    final id = newUser.id;
    Map<String, AuthUser> models = {if (state.userModels != null) ...state.userModels!};

    models[id] = newUser;

    final currentID = state.activeUserID ?? id;

    await MultiUserAccount.saveStorageUserModel(resultModels: models, activeUserID: currentID);
    emit(
      AuthState(
        authMode: authMode,
        multiUserAccount: MultiUserAccount(
          userModels: models,
          activeSignedInUserID: state.activeUserID ?? newUser.id,
          //
        ),
      ),
    );

    if (models.length == 1) {
      await switchAccout(userID: id);
    }
  }

  Future<void> signOut({bool allAccount = false, String? signOutID}) async {
    final oldState = state.copyWith();
    String? newActiveUserID;

    if (allAccount) {
      await secureStorage.deleteAll();

      emit(AuthState(authMode: authMode));
      return;
    } else {
      final currentUserID = state.activeUserID;
      final isCurrentUserID = signOutID == state.activeUserID;
      final signOutUserID = (signOutID != null && (state.userModels?.containsKey(signOutID) ?? false))
          ? signOutID
          : state.activeUserID;
      if (signOutUserID != null) {
        await secureStorage.deleteAllUserData(userID: signOutUserID);
        // state.userModels?.remove(signOutUserID);
        final userModels = state.userModels != null ? {...state.userModels!} : null;
        userModels?.remove(signOutUserID);

        if (userModels != null && userModels.isNotEmpty) {
          final Map<String, AuthUser> newModels = {};
          newActiveUserID = isCurrentUserID ? userModels.keys.first : currentUserID;
          userModels.forEach((key, value) {
            newModels[key] = value;
          });

          final saved = await MultiUserAccount.saveStorageUserModel(
            activeUserID: newActiveUserID,
            resultModels: newModels,
          );

          if (saved) {
            emit(
              AuthState(
                authMode: authMode,
                multiUserAccount: newModels.isNotEmpty
                    ? MultiUserAccount(userModels: Map.from(newModels), activeSignedInUserID: newActiveUserID)
                    : MultiUserAccount.setNull(),
              ),
            );
          } else {
            // keep the old state
            await MultiUserAccount.saveStorageUserModel(
              activeUserID: oldState.activeUserID,
              resultModels: oldState.userModels,
            );
            emit(oldState);
          }
        } else {
          await secureStorage.deleteAll();
          emit(AuthState(authMode: authMode));
        }
      }
    }
  }

  FutureOr onUserSignOutEvent() async {
    emit(AuthState(authMode: authMode));
  }
}
