import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../../utils/helpers/log.dart';
import 'http_interface.dart';

class Http implements IHttp {
  final Dio clientHttp = Dio(
    BaseOptions(
      baseUrl: 'https://economia.awesomeapi.com.br/json/last/',
      receiveDataWhenStatusError: true,
    ),
  );

  Dio _build({required String baseUrl}) {
    clientHttp.options.baseUrl = baseUrl;

    clientHttp.options.headers['Accept'] = 'application/json';
    clientHttp.options.headers['Content-Type'] = 'application/json';
    return clientHttp;
  }

  void logResponse(String method, String endpoint, String baseUrl, bool isSuccess) {
    final successStatus = isSuccess ? 'SUCESSO' : 'FALHA';
    Log.print(
      '$method em ${endpoint.isNotEmpty ? 'Endpoint: $endpoint' : "Url: $baseUrl$endpoint"} teve $successStatus',
      backgroundColor: isSuccess ? LogColor.GREEN : LogColor.RED,
      textColor: isSuccess ? LogColor.BLACK : LogColor.WHITE,
    );
  }

  @override
  Future<HttpResponse<T>> get<T>({
    required String endpoint,
    required String baseUrl,
    int timeout = 25,
    Options? options,
  }) async {
    try {
      final response = await _build(baseUrl: baseUrl).get(endpoint, options: options).timeout(
            Duration(seconds: timeout),
          );
      if (foundation.kDebugMode) logResponse('Get', endpoint, baseUrl, true);
      return HttpResponse<T>(
        data: response.data,
        statusCode: response.statusCode!,
      );
    } catch (e, s) {
      if (foundation.kDebugMode) logResponse('Get', endpoint, baseUrl, false);
      throw errorHandler(e, stackTrace: s);
    }
  }

  @override
  Future<HttpResponse<T>> post<T>({
    required String endpoint,
    required dynamic data,
    required String baseUrl,
    int timeout = 25,
    Options? options,
  }) async {
    try {
      final response = await _build(
        baseUrl: baseUrl,
      )
          .post(
            endpoint,
            data: data,
            options: options,
          )
          .timeout(
            Duration(
              seconds: timeout,
            ),
          );
      if (foundation.kDebugMode) logResponse('Post', endpoint, baseUrl, true);
      return HttpResponse<T>(
        data: response.data,
        statusCode: response.statusCode!,
      );
    } catch (e, s) {
      if (foundation.kDebugMode) logResponse('Post', endpoint, baseUrl, false);
      throw errorHandler(e, stackTrace: s);
    }
  }

  HttpFailure errorHandler(Object e, {StackTrace? stackTrace}) {
    if (e is DioException) {
      if (e.error is SocketException) {
        return HttpFailure(
          message: 'semConexao',
          statusCode: 503,
        );
      }
      return HttpFailure(
        message: 'erroDesconhecido',
        statusCode: e.response?.statusCode ?? 500,
      );
    } else if (e is TimeoutException) {
      return HttpFailure(
        message: 'timeOutMensagem',
        statusCode: 408,
      );
    } else {
      return HttpFailure(
        message: 'erroGenerico',
      );
    }
  }
}
