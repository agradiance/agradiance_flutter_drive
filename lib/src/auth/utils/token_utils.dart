import 'package:agradiance_flutter_drive/src/auth/models/auth_state.dart';
import 'package:agradiance_flutter_drive/src/auth/models/token_model.dart';
import 'package:agradiance_flutter_drive/src/services/app_navigator_service.dart';
import 'package:agradiance_flutter_drive/src/services/app_secure_storage.dart';
import 'package:flutter/material.dart';

abstract class TokenUtils {
  static Future veryfyTokenExpiration({required String userID}) async {
    final isUserTokenValid = await TokenUtils.isUserTokenValid(userID: userID);
    //dprint(["object", isUserTokenValid]);
    if (!isUserTokenValid) {
      final appMainNavigationService = AppMainNavigationService();
      return await showDialog(
        context: appMainNavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text('Token expired'),
              content: Text('User token has expired, please sign in to continue'),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static Future veryfyUserAuthTokensExpiration({
    required AuthUser activeUser,
    required String username,
    void Function()? signOutCallback,
    void Function()? onSigninPressed,
  }) async {
    final userID = activeUser.id;

    final tokenModel = await TokenUtils.getTokenModel(userID: userID);

    // dprint(tokenModel);
    // return tokenModel?.accessToken;

    if (tokenModel != null && !(tokenModel.isUserRefreshTokenValid)) {
      final appMainNavigationService = AppMainNavigationService();
      signOutCallback?.call(); // Sign the user out
      return await showDialog(
        context: appMainNavigationService.navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text('Token expired'),
              content: Text('Token for the user @$username has expired, please sign in to continue'),
              actions: [
                TextButton(onPressed: onSigninPressed, child: Text('Signin')),
                TextButton(
                  child: Text('Close'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static Future<void> saveUserTokenModelToStorage({required TokenModel tokenModel}) async {
    final userID = tokenModel.userID;
    final value = tokenModel.toJson();
    final appSStorare = AppSecureStorage();
    await appSStorare.writeUserValue(userID: userID, ref: TokenModel.modelRefKey, value: value);
  }

  static Future<TokenModel?> getTokenModel({required String userID}) async {
    final appSStorare = AppSecureStorage();

    final json = await appSStorare.readUserValue(userID: userID, key: TokenModel.modelRefKey);
    if (json != null) {
      return TokenModel.fromJson(json);
    }
    return null;
  }

  static Future<bool> isUserTokenValid({required String userID}) async {
    final tokenModel = await getTokenModel(userID: userID);
    return tokenModel?.isUserAccessTokenValid ?? false;
  }
}
