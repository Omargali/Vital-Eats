import 'package:dio/dio.dart';
import 'package:dio/io.dart';


class AppDio {
  AppDio({
      Dio? httpClient,
    }) : httpClient = httpClient ?? Dio()
          ..options.contentType = 'application/json'
          ..options.connectTimeout = _defaultTimeout
          ..options.receiveTimeout = _defaultTimeout
          ..options.sendTimeout = _defaultTimeout
          ..interceptors.add(
            LogInterceptor(
              request: false,
              requestHeader: false,
              responseHeader: false,
            ),
          )
          ..httpClientAdapter = IOHttpClientAdapter();

  final Dio httpClient;

  static const _defaultTimeout = Duration(seconds: 20);
}
