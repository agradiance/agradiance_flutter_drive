// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
// import 'dart:io';

import 'package:agradiance_flutter_drive/src/encrypt/encrypt_utils.dart';
import 'package:agradiance_flutter_drive/src/errors/exceptions.dart';
import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
import 'package:http_status/http_status.dart';

//
class _ApiResponse<T> {
  final T responseData;
  final int? statusCode;
  final Response response;

  T get data => responseData;

  _ApiResponse({required this.responseData, required this.statusCode, required this.response});
}

class RestApiService {
  RestApiService._(this._client);
  static final RestApiService _internal = RestApiService._(Dio(BaseOptions(receiveDataWhenStatusError: true)));
  factory RestApiService() => _internal;
  static RestApiService get instance => RestApiService();

  final Dio _client;

  String? _baseUrl;
  String _responseMessageKey = "message";
  String _responseDataKey = "data";
  Duration _connectTimeout = Duration(seconds: 20);

  String get responseMessageKey => _responseMessageKey;
  String get responseDataKey => _responseDataKey;

  Dio get client => _client;

  void addInterceptor({required Interceptor interceptor}) {
    _client.interceptors.add(interceptor);
  }

  void addAllInterceptors({required List<Interceptor> interceptor}) {
    _client.interceptors.addAll(interceptor);
  }

  bool removeInterceptor({required Interceptor interceptor}) {
    return _client.interceptors.remove(interceptor);
  }

  void cancelRequest() {
    _client.close();
  }

  /// [config] should be called earlier to initialize and set up the service
  Future<void> config({
    String? baseUrl,
    String responseMessageKey = "message",
    String responseDataKey = "data",
    Duration connectTimeout = const Duration(seconds: 20),
    required List<Interceptor>? interceptors,
    bool ping = false,
    String? pingUrl,
  }) async {
    assert((ping == false || (ping == true && pingUrl != null)), "pingUrl must not be null when ping is true");

    _baseUrl = baseUrl;
    _connectTimeout = connectTimeout;
    _responseDataKey = responseDataKey;
    _responseMessageKey = responseMessageKey;

    // set client
    _client.options = _client.options.copyWith(baseUrl: baseUrl, connectTimeout: connectTimeout);

    if (interceptors != null) {
      addAllInterceptors(interceptor: interceptors);
    }

    if (ping && pingUrl != null) {
      await pingApi(pingUrl);
    }
    //
  }

  Future<void> pingApi([String? url]) async {
    try {
      if (url != null) {
        await Dio().get(url);
      } else if (_baseUrl != null) {
        await Dio().get(_baseUrl!);
      }
    } on Exception {
      rethrow;
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
        ? dioExceptionData[_responseMessageKey]?.toString() ?? dioExceptionData["detail"]?.toString()
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

  void setVerifyUserAuthTokensExpiration(Future<void> Function()? veryfyUserAuthTokensExpirationCallBack) {
    this.veryfyUserAuthTokensExpirationCallBack = veryfyUserAuthTokensExpirationCallBack;
  }

  Future<void> Function()? veryfyUserAuthTokensExpirationCallBack;

  Future<_ApiResponse<T>> _handleResponse<T>(
    Future<Response> Function() request, {
    bool encryptedResponse = false,
    String? responseMessageKey,
    String? responseDataKey,
  }) async {
    try {
      await veryfyUserAuthTokensExpirationCallBack?.call();
      final response = await request();
      final message = response.data[responseMessageKey ?? this._responseMessageKey];

      // dprint(response.data["data"]);

      final body = encryptedResponse
          ? {
              "message": message,
              "data": EncryptUtils.instance.decryptFrom64ToType(
                data: response.data[responseDataKey ?? this._responseDataKey],
              ),
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
    String? responseMessageKey,
    String? responseDataKey,
    int? timeoutSeconds,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      responseDataKey: responseDataKey ?? this._responseDataKey,
      responseMessageKey: responseMessageKey ?? this._responseMessageKey,
      () => _client
          .fetch(requestOptions)
          .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    );
  }

  Future<dynamic> download<T>(
    String url,
    String path, {
    bool encryptedResponse = false,
    Map<String, String>? headers,
    int? timeoutSeconds,
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
        .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout);
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
    //       .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    // );
  }

  Future<_ApiResponse<T>> get<T>(
    String url, {
    String? responseMessageKey,
    String? responseDataKey,
    bool encryptedResponse = false,
    Map<String, String>? headers,
    int? timeoutSeconds,
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
      responseDataKey: responseDataKey ?? this._responseDataKey,
      responseMessageKey: responseMessageKey ?? this._responseMessageKey,
      () => _client
          .get(
            url,
            options: options ?? Options(headers: headers),
            queryParameters: queryParameters,
            data: formData ?? data,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
          )
          .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    );
  }

  Future<_ApiResponse<T>> post<T>(
    String url, {
    bool encryptedResponse = false,
    String? responseMessageKey,
    String? responseDataKey,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    int? timeoutSeconds,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      responseDataKey: responseDataKey ?? this._responseDataKey,
      responseMessageKey: responseMessageKey ?? this._responseMessageKey,
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
          .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    );
  }

  Future<_ApiResponse<T>> put<T>(
    String url, {
    bool encryptedResponse = false,
    String? responseMessageKey,
    String? responseDataKey,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    Encoding? encoding,
    int? timeoutSeconds,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      responseDataKey: responseDataKey ?? this._responseDataKey,
      responseMessageKey: responseMessageKey ?? this._responseMessageKey,
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
          .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    );
  }

  Future<_ApiResponse<T>> patch<T>(
    String url, {
    bool encryptedResponse = false,
    String? responseMessageKey,
    String? responseDataKey,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    Encoding? encoding,
    int? timeoutSeconds,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      responseDataKey: responseDataKey ?? this._responseDataKey,
      responseMessageKey: responseMessageKey ?? this._responseMessageKey,
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
          .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    );
  }

  Future<_ApiResponse<T>> delete<T>(
    String url, {
    bool encryptedResponse = false,
    String? responseMessageKey,
    String? responseDataKey,
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    FormData? formData,
    Encoding? encoding,
    int? timeoutSeconds,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _handleResponse(
      encryptedResponse: encryptedResponse,
      responseDataKey: responseDataKey ?? this._responseDataKey,
      responseMessageKey: responseMessageKey ?? this._responseMessageKey,
      () => _client
          .delete(
            url,
            options: options ?? Options(headers: headers),
            data: formData ?? data,
            queryParameters: queryParameters,
          )
          .timeout(timeoutSeconds != null ? Duration(seconds: timeoutSeconds) : _connectTimeout),
    );
  }
}
