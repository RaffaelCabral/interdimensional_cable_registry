import 'dart:developer' as dev;

import 'package:dio/dio.dart';

class HttpInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    dev.log('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
    dev.log('🌐 Headers: ${options.headers}');
    dev.log('🌐 Data: ${options.data}');
    dev.log('🌐 Query Parameters: ${options.queryParameters}');
    
    // Adicionar headers padrão se necessário
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    dev.log('✅ Data: ${response.data}');
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    dev.log('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    dev.log('❌ Message: ${err.message}');
    dev.log('❌ Error Type: ${err.type}');
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        dev.log('❌ Connection timeout');
        break;
      case DioExceptionType.sendTimeout:
        dev.log('❌ Send timeout');
        break;
      case DioExceptionType.receiveTimeout:
        dev.log('❌ Receive timeout');
        break;
      case DioExceptionType.badResponse:
        dev.log('❌ Bad response: ${err.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        dev.log('❌ Request cancelled');
        break;
      case DioExceptionType.connectionError:
        dev.log('❌ Connection error');
        break;
      case DioExceptionType.unknown:
        dev.log('❌ Unknown error');
        break;
      case DioExceptionType.badCertificate:
        dev.log('❌ Bad certificate');
        break;
    }
    
    handler.next(err);
  }
}
