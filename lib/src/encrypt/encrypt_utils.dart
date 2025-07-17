import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

final class EncryptUtils {
  EncryptUtils._();
  static final EncryptUtils _internal = EncryptUtils._();
  static EncryptUtils get instance {
    return _internal;
  }

  Key? _encryptKey;
  IV? _encryptIv;

  void initializeEncryptParams({required String utf8Key, required String utf8Iv}) {
    _encryptKey = Key.fromUtf8(utf8Key);
    _encryptIv = IV.fromUtf8(utf8Iv);
  }

  Encrypter get _defaultEncrypter => Encrypter(
    // AES(_defaultKey, mode: AESMode.cbc),
    AES(_defaultKey, mode: AESMode.cbc, padding: 'PKCS7'),
  );

  Encrypter get _defaultDecrypter => Encrypter(
    // AES(_defaultKey, mode: AESMode.cbc),
    AES(_defaultKey, mode: AESMode.cbc, padding: 'PKCS7'),
  );

  Key get _defaultKey => _encryptKey ?? Key.fromLength(32);
  IV get _defaultIv => _encryptIv ?? IV.fromLength(16);

  Encrypted encrypt({required String input, Uint8List? associatedData}) {
    return _defaultEncrypter.encrypt(input, iv: _defaultIv, associatedData: associatedData);
  }

  String encryptToBase64({required String input, Uint8List? associatedData}) {
    return _defaultEncrypter.encrypt(input, iv: _defaultIv, associatedData: associatedData).base64;
  }

  Encrypted encryptMap({required Map<String, dynamic> input, Uint8List? associatedData}) {
    return encrypt(input: jsonEncode(input), associatedData: associatedData);
  }

  String encryptMapToBase64({required Map<String, dynamic> input, Uint8List? associatedData}) {
    return encryptMap(input: input, associatedData: associatedData).base64;
  }

  String decrypt({required Encrypted encrypted, Uint8List? associatedData}) {
    return _defaultDecrypter.decrypt(encrypted, iv: _defaultIv, associatedData: associatedData);
  }

  String decryptFrom64({required String data, Uint8List? associatedData}) {
    final encryptedBytes = Encrypted.from64(data);
    final resp = decrypt(encrypted: encryptedBytes, associatedData: associatedData);
    return resp;
  }

  T decryptFrom64ToType<T>({required String data, Uint8List? associatedData}) {
    return jsonDecode(decryptFrom64(data: data, associatedData: associatedData));
  }
}
