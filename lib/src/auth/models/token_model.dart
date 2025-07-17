// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:agradiance_flutter_drive/src/utils/num_utils.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  static String modelRefKey = "AUTH_TOKEN_MODEL_REF_KEY";
  static String tokenValueRefKey = "AUTH_TOKEN_VALUE_REF_KEY";
  final String userID;
  final String accessToken;
  final String refreshToken;
  final DateTime updatedAt;

  const TokenModel({
    required this.userID,
    required this.accessToken,
    required this.refreshToken,
    required this.updatedAt,
  });

  TokenModel.now({
    required this.userID, //
    required this.accessToken, //
    required this.refreshToken, //
  }) : updatedAt = DateTime.now();

  static Map<String, dynamic>? decodePayload({required String token}) {
    try {
      return JWT.decode(token).payload;
    } on JWTUndefinedException {
      return null;
    }
  }

  DateTime? tokenExpiresIn({required String jwtToken}) {
    final token = decodePayload(token: jwtToken);
    if (token != null && token["exp"] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        NumUtils.parseOrNullValue(token["exp"], orNullValue: 0)!.toInt() * 1000,
      );
    } else {
      return null;
    }
  }

  DateTime get accessTokenExpiresIn {
    return tokenExpiresIn(jwtToken: accessToken) ?? DateTime.now();
  }

  DateTime get refreshTokenExpiresIn {
    return tokenExpiresIn(jwtToken: refreshToken) ?? DateTime.now();
  }

  bool get isUserAccessTokenValid {
    return accessTokenExpiresIn.isAfter(DateTime.now());
  }

  bool get isUserRefreshTokenValid {
    return refreshTokenExpiresIn.isAfter(DateTime.now());
  }

  bool get hasAccessTokenExpired {
    return accessTokenExpiresIn.isBefore(DateTime.now());
  }

  bool get hasRefreshTokenExpired {
    return refreshTokenExpiresIn.isBefore(DateTime.now());
  }

  TokenModel copyWith({
    String? userID,
    String? accessToken,
    String? refreshToken,
    DateTime? updatedAt,
  }) {
    return TokenModel(
      userID: userID ?? this.userID,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': accessTokenExpiresIn.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      userID: map['userID'] as String,
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? "") ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenModel.fromJson(String source) =>
      TokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [
    userID,
    accessToken,
    refreshToken,
    accessTokenExpiresIn,
    refreshTokenExpiresIn,
    updatedAt,
  ];

  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'TokenModel(userID: $userID, accessToken: $accessToken, accessTokenExpiresIn: $accessTokenExpiresIn, refreshTokenExpiresIn: $refreshTokenExpiresIn, refreshToken: $refreshToken, updatedAt: $updatedAt)';
  }
}
