// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
// import 'dart:io';

import 'package:agradiance_flutter_drive/src/encrypt/encrypt_utils.dart';
import 'package:agradiance_flutter_drive/src/errors/exceptions.dart';
import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
import 'package:http_status/http_status.dart';

class _ApiResponse<T> {
  final T responseData;
  final int? statusCode;
  final Response response;

  T get data => responseData;

  _ApiResponse({required this.responseData, required this.statusCode, required this.response});
}

abstract class AuthInterceptor extends Interceptor {
  Dio get client {
    return Dio(BaseOptions(receiveDataWhenStatusError: true));
  }

  AuthInterceptor();

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   if (err.response?.statusCode == 401) {
  //     final authRepository = GetIt.I.get<AuthRepository>();
  //     final authBloc = GetIt.I.get<AuthBloc>();
  //     // Token expired

  //     final userID = authBloc.model.multiUserAccount.activeSignedInUserID;

  //     if (userID != null) {
  //       final tokenModel = await TokenUtils.getTokenModel(userID: userID);

  //       if (tokenModel != null && tokenModel.hasAccessTokenExpired && (!tokenModel.hasRefreshTokenExpired)) {
  //         final refreshToken = tokenModel.refreshToken;
  //         final encryptedString = EncryptUtils.instance.encryptMapToBase64(input: {"refreshToken": refreshToken});
  //         final result = await authRepository.refreshToken(data: {"data": encryptedString});

  //         await result.fold((left) {}, (right) async {
  //           final data = right["data"] is Map ? right["data"] : {};
  //           final newAccessToken = data['accessToken']?.toString();
  //           final newRefreshToken = data['refreshToken']?.toString();

  //           if (newAccessToken != null && newRefreshToken != null) {
  //             final tokenModel = TokenModel(
  //               userID: userID,
  //               accessToken: newAccessToken,
  //               refreshToken: newRefreshToken,
  //               updatedAt: DateTime.now(),
  //             );
  //             await TokenUtils.saveUserTokenModelToStorage(tokenModel: tokenModel);

  //             err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

  //             // Retry the request
  //             final response = await _client.fetch(err.requestOptions);
  //             handler.resolve(response);
  //             return;
  //           }
  //         });
  //       }
  //     }
  //   }

  //   handler.next(err);
  // }
}

class RestApiService {
  RestApiService._(this._client);
  static final RestApiService _internal = RestApiService._(Dio(BaseOptions(receiveDataWhenStatusError: true)));
  factory RestApiService() => _internal;
  static RestApiService get instance => RestApiService();

  final Dio _client;

  Dio get client => _client;

  void addInterceptor({required Interceptor interceptor}) {
    _client.interceptors.add(interceptor);
  }

  bool removeInterceptor({required Interceptor interceptor}) {
    return _client.interceptors.remove(interceptor);
  }

  void cancelRequest() {
    _client.close();
  }

  Future<void> pingApi(String url) async {
    try {
      await Dio().get(url);
    } on Exception {
      //
    }
  }

  Never _throwDioException(DioException dioException) {
    // dprint(name: "dioException.response", [
    //   dioException.response?.statusMessage,
    //   dioException.response?.data,
    //   dioException.response,
    //   dioException.error,
    //   dioException.message,
    // ]);

    final dioExceptionData = dioException.response?.data;
    final statusMessage = dioException.response?.statusMessage;
    final message = dioExceptionData != null && dioExceptionData is Map
        ? dioExceptionData["message"]?.toString() ?? dioExceptionData["detail"]?.toString()
        : dioExceptionData is String
        ? dioExceptionData.toString()
        : statusMessage;

    final statusCode = dioException.response?.statusCode;
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        throw APIException(message: message ?? "Request timed out", statusCode: statusCode);
      case DioExceptionType.sendTimeout:
        throw APIException(
          message: message ?? "The request could not be sent within the allowed time",
          statusCode: statusCode,
        );
      case DioExceptionType.receiveTimeout:
        throw APIException(message: message ?? "The server took too long to send a response", statusCode: statusCode);
      case DioExceptionType.badCertificate:
        throw APIException(message: message ?? "Certificate verification failed", statusCode: statusCode);
      case DioExceptionType.badResponse:
        throw APIException(message: message ?? "Bad response, wrong request format", statusCode: statusCode);
      case DioExceptionType.cancel:
        throw APIException(message: message ?? "Request canceled", statusCode: statusCode);
      case DioExceptionType.connectionError:
        throw APIException(message: message ?? "No internet connection or network failure", statusCode: statusCode);
      case DioExceptionType.unknown:
        throw APIException(message: message ?? "An unexpected error occurred", statusCode: statusCode);
    }
  }

  Never throwException(Exception exception) {
    if (exception is DioException) {
      throw _throwDioException(exception);
    } else if (exception is TimeoutException) {
      throw APIException(message: exception.message ?? 'Connection Timeout please retry', statusCode: 100);
    } else {
      //dprint(exception.toString(), stackTrace: StackTrace.current);
      throw APIException(message: exception.toString(), statusCode: -1);
    }
  }

  setVerifyUserAuthTokensExpiration(Future<void> Function()? veryfyUserAuthTokensExpirationCallBack) {
    this.veryfyUserAuthTokensExpirationCallBack = veryfyUserAuthTokensExpirationCallBack;
  }

  Future<void> Function()? veryfyUserAuthTokensExpirationCallBack;

  Future<_ApiResponse<T>> _handleResponse<T>(
    Future<Response> Function() request, {
    bool encryptedResponse = false,
  }) async {
    try {
      await veryfyUserAuthTokensExpirationCallBack?.call();
      final response = await request();
      final message = response.data["message"];

      // dprint(response.data["data"]);

      final body = encryptedResponse
          ? {
              "message": message,
              "data": EncryptUtils.instance.decryptFrom64ToType(data: response.data["data"]),
              // "data": EncryptUtils.decryptFrom64ToType<Map<String, dynamic>>(data: response.data["data"]),
            }
          : response.data;

      if (response.statusCode?.isSuccessfulHttpStatusCode ?? false) {
        return _ApiResponse(responseData: body, statusCode: response.statusCode, response: response);
      } else {
        //dprint(response.statusMessage, stackTrace: StackTrace.current);
        throw APIException(
          message: message ?? response.statusMessage ?? "Error occured",
          statusCode: response.statusCode,
        );
      }
    } on Exception catch (exception) {
      throw throwException(exception);
    }
  }

  Future<_ApiResponse<T>> fetch<T>({
    required RequestOptions requestOptions,
    bool encryptedResponse = false,
    int timeoutSeconds = 40,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      () => _client.fetch(requestOptions).timeout(Duration(seconds: timeoutSeconds)),
    );
  }

  Future<dynamic> download<T>(
    String url,
    String path, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    int timeoutSeconds = 40,
    Options? options,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return _client
        .download(
          url,
          path,
          options: options ?? Options(headers: headers),
          queryParameters: queryParameters,
          data: formData ?? data,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        )
        .timeout(Duration(seconds: timeoutSeconds));
    // return _handleResponse(
    //   encryptedResponse: encryptedResponse,
    //   () => _client
    //       .download(
    //         url,
    //         path,
    //         options: options ?? Options(headers: headers),
    //         queryParameters: queryParameters,
    //         data: formData ?? data,
    //         cancelToken: cancelToken,
    //         onReceiveProgress: onReceiveProgress,
    //       )
    //       .timeout(Duration(seconds: timeoutSeconds)),
    // );
  }

  Future<_ApiResponse<T>> get<T>(
    String url, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    int timeoutSeconds = 40,
    Options? options,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      () => _client
          .get(
            url,
            options: options ?? Options(headers: headers),
            queryParameters: queryParameters,
            data: formData ?? data,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          )
          .timeout(Duration(seconds: timeoutSeconds)),
    );
  }

  Future<_ApiResponse<T>> post<T>(
    String url, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    int timeoutSeconds = 40,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      () => _client
          .post(
            url,
            options: options ?? Options(headers: headers),
            queryParameters: queryParameters,
            data: formData ?? data,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
          )
          .timeout(Duration(seconds: timeoutSeconds)),
    );
  }

  Future<_ApiResponse<T>> put<T>(
    String url, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    Encoding? encoding,
    int timeoutSeconds = 40,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      () => _client
          .put(
            url,
            options: options ?? Options(headers: headers),
            queryParameters: queryParameters,
            data: formData ?? data,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
          )
          .timeout(Duration(seconds: timeoutSeconds)),
    );
  }

  Future<_ApiResponse<T>> patch<T>(
    String url, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    Encoding? encoding,
    int timeoutSeconds = 40,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      () => _client
          .patch(
            url,
            options: options ?? Options(headers: headers),
            data: formData ?? data,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            queryParameters: queryParameters,
          )
          .timeout(Duration(seconds: timeoutSeconds)),
    );
  }

  Future<_ApiResponse<T>> delete<T>(
    String url, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    Encoding? encoding,
    int timeoutSeconds = 40,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      () => _client
          .delete(
            url,
            options: options ?? Options(headers: headers),
            data: formData ?? data,
            queryParameters: queryParameters,
          )
          .timeout(Duration(seconds: timeoutSeconds)),
    );
  }
}
