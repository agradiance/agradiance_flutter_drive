import 'package:agradiance_flutter_drive/agradiance_flutter_drive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:collection/collection.dart';
import 'package:permission_handler/permission_handler.dart';

class AppSecureStorage {
  static final AppSecureStorage _internal = AppSecureStorage._initialize(
    FlutterSecureStorage(
      aOptions: _aOptions(),
      iOptions: _iOptions(),
      lOptions: _lOptions(),
      mOptions: _mOptions(),
      wOptions: _wOptions(),
      webOptions: _webOptions(),
    ),
  );
  AppSecureStorage._initialize(this._storage);

  factory AppSecureStorage() => _internal;
  static AppSecureStorage get instance => AppSecureStorage();

  final FlutterSecureStorage _storage;

  static AndroidOptions _aOptions() =>
      AndroidOptions(encryptedSharedPreferences: true);
  static IOSOptions _iOptions() => IOSOptions.defaultOptions;
  static LinuxOptions _lOptions() => LinuxOptions.defaultOptions;
  static MacOsOptions _mOptions() => MacOsOptions.defaultOptions;
  static WindowsOptions _wOptions() => WindowsOptions.defaultOptions;
  static WebOptions _webOptions() => WebOptions.defaultOptions;

  /*
  Read ........................
   */

  Future<Map<String, String>> _readAll() {
    return _storage.readAll();
  }

  Future<Map<String, String>> _allData() => _readAll();
  Future<String?> _read({required String key}) async {
    // if (await AppPermissionService.instance.isPermissionGranted(Permission.storage)) {
    return _storage.read(key: key);
    // }

    return null;
  }

  Future<String?> readUserValue({
    required String userID,
    required String key,
  }) => _read(key: "${userID.toLowerCase()}:$key");

  Future<Map<String, String>?> readRefKeyValues({
    required String refKeyValue,
  }) async {
    Map<String, String> result = {};

    for (final data in (await _allData()).entries) {
      if (data.key.contains(refKeyValue)) {
        result[data.key] = data.value;
      }
    }

    return result.isNotEmpty ? result : null;
  }

  Future<({String? key, String? value})> readFirstRefKeyValue({
    required String refKeyValue,
  }) async {
    String? key;
    String? value;

    final result = (await _allData()).entries.firstWhereOrNull((element) {
      return element.key.contains(refKeyValue);
    });

    key = result?.key;
    value = result?.value;

    return (key: key, value: value);
  }

  Future<String?> read({required String refKey}) async {
    return await _storage.read(key: refKey);
  }

  // Is key used
  Future<bool> containsKey({required String userID, required String key}) {
    return _storage.containsKey(
      key: '${userID.toLowerCase()}:$key',
      aOptions: _aOptions(),
      iOptions: _iOptions(),
      lOptions: _lOptions(),
    );
  }

  // Is key saved
  Future<bool> isUserDataSaved({
    required String userID,
    required String key,
    required String? value,
  }) async {
    return (await _allData())["${userID.toLowerCase()}:$key"] == value;
  }

  /* Write value
  ....................................
  */
  Future<bool> _writeValue({
    required String keyRef,
    required String? value,
  }) async {
    // final status = await AppPermissionService.instance
    //     .requestMultipleAndSettiings([Permission.storage]);
    // if (status[Permission.storage]?.isGranted ?? false) {
    // if (await Permission.storage.isGranted ?? false) {
    await _storage.write(
      key: keyRef,
      value: value,
      aOptions: _aOptions(),
      iOptions: _iOptions(),
      lOptions: _lOptions(),
    );
    // }

    final getValue = await _read(key: keyRef);
    if (getValue == value) {
      return true;
    } else {
      return false;
    }
  }

  // Write value
  Future<bool> writeUserValue({
    required String userID,
    required String ref,
    required String? value,
  }) async {
    return _writeValue(keyRef: '${userID.toLowerCase()}:$ref', value: value);
  }

  Future<bool> writeWithCombinedKey({
    required String combinedKey,
    required String? value,
  }) {
    return _writeValue(keyRef: combinedKey, value: value);
  }

  // Delete value
  Future<void> deleteWithUserIDKey({
    required String userID,
    required String key,
  }) => _storage.delete(key: '$userID:$key');

  // Delete value
  Future<void> deleteDataWithCombinedKey({required String combinedKey}) =>
      _storage.delete(key: combinedKey);

  Future<void> deleteAllUserData({required String userID}) async {
    // Delete a specific user data that contains a particular string
    final data = await _allData();

    for (final map in data.entries) {
      if (map.key.toLowerCase().trim().startsWith(userID.toLowerCase())) {
        await deleteDataWithCombinedKey(combinedKey: map.key);
      }
    }
  }

  Future<void> deleteValueWithAllTagInRequiredList({
    String? userID,
    required List<String> requiredList,
  }) async {
    // Delete a specific user data that contains a particular string
    final data = await _allData();
    for (final map in data.entries) {
      final status = requiredList.every((element) {
        return [
          if (userID != null) ...[
            map.key.toLowerCase().trim().startsWith(userID.toLowerCase()),
          ],
          map.key.toLowerCase().contains(element.toLowerCase()),
        ].every((element) => element);
      });
      if (status) {
        await deleteDataWithCombinedKey(combinedKey: map.key);
      }
    }
  }

  Future<void> deleteValueWithAnyTagInRequiredList({
    String? userID,
    required List<String> requiredList,
  }) async {
    // Delete a specific user data that contains a particular string
    final data = await _allData();
    for (final map in data.entries) {
      final status = requiredList.any((element) {
        return [
          if (userID != null) ...[
            map.key.toLowerCase().trim().startsWith(userID.toLowerCase()),
          ],
          map.key.toLowerCase().contains(element.toLowerCase()),
        ].every((element) => element);
      });
      if (status) {
        await deleteDataWithCombinedKey(combinedKey: map.key);
      }
    }
  }

  Future<void> deleteAllKeyPattern({required Pattern pattern}) async {
    // Delete all key pattern
    final data = await _allData();
    for (final entry in data.entries) {
      if (entry.key.contains(pattern)) {
        await deleteDataWithCombinedKey(combinedKey: entry.key);
      }
    }
  }

  // Delete all

  Future<void> _deleteAll() async {
    return _storage.deleteAll();
  }

  Future<void> deleteAll({String? userID}) async {
    // Delete a specific user data that contains a particular string
    if (userID == null) {
      return _deleteAll();
    } else {
      return deleteAllUserData(userID: userID);
    }
  }
}
