// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agradiance_flutter_drive/src/services/app_secure_storage.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:flutter/foundation.dart';

abstract class AuthUser {
  final String id;

  AuthUser({
    required this.id,
    required AuthUser Function(String json) fromJsonFile,
    required AuthUser Function(Map<String, dynamic> map) fromMap,
  });

  String toJson();
}

enum AuthMode {
  single,
  multiple;

  bool get isSingle => this == single;
  bool get isMultiple => this == multiple;
}

class MultiUserAccount {
  static AppSecureStorage get secureStorage => AppSecureStorage.instance;
  static final String multiUserRefKey = "MULTI_USER_STORAGE_REF_KEY";
  static final String multiUserActiveUserIDRefKey = "MULTI_USER_ACTIVE_USER_ID_STORAGE_REF_KEY";

  MultiUserAccount({
    this.userModels,
    this.activeSignedInUserID,
    required AuthUser Function(String json)? fromJsonFile,
    required AuthUser Function(Map<String, dynamic> map)? fromMap,
  }) {
    _fromJsonFile = fromJsonFile ?? _fromJsonFile;
    _fromMap = fromMap ?? _fromMap;
  }

  MultiUserAccount.setNull() : this(fromJsonFile: null, fromMap: null);

  static AuthUser Function(String json)? _fromJsonFile;
  static AuthUser Function(Map<String, dynamic> map)? _fromMap;

  ///
  static void updateSerializerFunctions({
    required AuthUser Function(String json)? fromJsonFile,
    required AuthUser Function(Map<String, dynamic> map)? fromMap,
  }) {
    _fromJsonFile = fromJsonFile;
    _fromMap = fromMap;
  }

  static Future<MultiUserAccount> loadFromStorage() async {
    final models = await getStorageUserModel();
    final id = await getStorageUserActiveID();

    return MultiUserAccount(
      userModels: models,
      activeSignedInUserID: id,
      fromJsonFile: _fromJsonFile,
      fromMap: _fromMap,
    );
  }

  final Map<String, AuthUser>? userModels;
  final String? activeSignedInUserID;

  AuthUser? getModel(String userID) => userModels?[userID];
  AuthUser? get currentSignedInModel => activeSignedInUserID != null ? (userModels?[activeSignedInUserID]) : null;

  static Future<String?> getStorageUserActiveID() async {
    final result = await secureStorage.read(refKey: multiUserActiveUserIDRefKey);

    if (result != null) {
      return result;
    }

    return null;
  }

  static Future<Map<String, AuthUser>?> getStorageUserModel() async {
    Map<String, AuthUser>? resultModels;
    final result = await secureStorage.readRefKeyValues(refKeyValue: multiUserRefKey);

    if (result != null) {
      final models = result.entries.map((e) {
        final re = _fromJsonFile?.call(e.value);

        return re;
      }).nonNulls;

      for (final model in models) {
        final userID = model.id;

        (resultModels ??= {})[userID] = model;
      }
    }

    return resultModels;
  }

  static Future<void> saveActiveUserID({required String? id}) async {
    // final now = DateTime.now().toIso8601String();
    await secureStorage.writeWithCombinedKey(combinedKey: multiUserActiveUserIDRefKey, value: id);
  }

  static Future<bool> saveStorageUserModel({
    required String? activeUserID,
    required Map<String, AuthUser>? resultModels,
  }) async {
    if (resultModels?.isNotEmpty ?? false) {
      await saveActiveUserID(id: activeUserID);
      resultModels?.forEach((key, value) async {
        await secureStorage.writeUserValue(userID: key, ref: multiUserRefKey, value: value.toJson());
      });
    } else {
      await secureStorage.deleteAllKeyPattern(pattern: multiUserActiveUserIDRefKey);
      await secureStorage.deleteAllKeyPattern(pattern: multiUserRefKey);
    }

    final savedModel = await getStorageUserModel();
    final savedID = await getStorageUserActiveID();

    final saved = [
      savedID == activeUserID,
      DeepCollectionEquality().equals(resultModels, savedModel),
    ].every((element) => element);

    //dprint([
    //   saved,
    //   savedID,
    //   activeUserID,
    //   savedID == activeUserID,
    //   DeepCollectionEquality().equals(resultModels, savedModel),

    //   savedModel?.keys.toSet(),
    //   resultModels?.keys.toSet(),
    //   "savedmodel: $savedModel",
    //   "resultmodel: $resultModels",
    //   savedModel?.keys.toString(),
    //   resultModels?.keys.toString(),
    //   savedModel?.values.toString() == resultModels?.values.toString(),
    // ]);

    return saved;
  }

  MultiUserAccount copyWith({Map<String, AuthUser>? userModels, String? activeSignedInUserID}) {
    return MultiUserAccount(
      userModels: userModels ?? this.userModels,
      activeSignedInUserID: activeSignedInUserID ?? this.activeSignedInUserID,
      fromJsonFile: _fromJsonFile,
      fromMap: _fromMap,
    );
  }

  Future<MultiUserAccount> switchAccountAndSaveAccountID({required String newCurrentSignedInUserID}) async {
    await saveActiveUserID(id: newCurrentSignedInUserID);
    return copyWith(activeSignedInUserID: newCurrentSignedInUserID);
  }

  @override
  String toString() => 'MultiUserAccount(userModels: $userModels, activeSignedInUserID: $activeSignedInUserID)';

  @override
  bool operator ==(covariant MultiUserAccount other) {
    if (identical(this, other)) return true;

    return mapEquals(other.userModels, userModels) && other.activeSignedInUserID == activeSignedInUserID;
  }

  @override
  int get hashCode => userModels.hashCode ^ activeSignedInUserID.hashCode;
}
