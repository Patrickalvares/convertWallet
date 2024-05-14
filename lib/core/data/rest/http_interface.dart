import 'package:dio/dio.dart';

abstract interface class IHttp {
  Future<HttpResponse<T>> get<T>({
    required String endpoint,
    required String baseUrl,
    int timeout = 25,
    Options? options,
  });
  Future<HttpResponse<T>> post<T>({
    required String endpoint,
    required String baseUrl,
    int timeout = 25,
    Options? options,
  });
}

class HttpResponse<T> {
  HttpResponse({
    required this.data,
    required this.statusCode,
  });
  final T data;
  final int statusCode;
}

class HttpFailure implements Exception {
  HttpFailure({
    required this.message,
    this.statusCode = 500,
    this.stackTrace,
  });
  final String message;
  final int statusCode;
  final StackTrace? stackTrace;
}
