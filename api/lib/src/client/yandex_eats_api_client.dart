import 'dart:io';

import 'package:api/api.dart';
import 'package:dio/dio.dart';

/// {@template yandex_eats_api_malformed_response}
/// An exception thrown when there is a problem decoded the response body.
/// {@endtemplate}
class YandexEatsApiMalformedResponse implements Exception {
  /// {@macro yandex_eats_api_malformed_response}
  const YandexEatsApiMalformedResponse({required this.error});

  /// The associated error.
  final Object error;
}

/// {@template yandex_eats_api_request_failure}
/// An exception thrown when an http request failure occurs.
/// {@endtemplate}
class YandexEatsApiRequestFailure implements Exception {
  /// {@macro yandex_eats_api_request_failure}
  const YandexEatsApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The associated http status code.
  final int? statusCode;

  /// The associated response body.
  final Map<String, dynamic> body;
}

class YandexEatsClient {
  YandexEatsClient({
      required AppDio dio,
      required String baseUrl,
    }) : this._(dio: dio, urlBuilder: UrlBuilder(baseUrl: baseUrl));

  const YandexEatsClient.localhost({
  required AppDio dio,
}) : this._(
    dio: dio,
    urlBuilder: const UrlBuilder(baseUrl: 'http://10.0.2.2:8080/api/v1'),
);

  const YandexEatsClient._({
    required UrlBuilder urlBuilder,
    required AppDio dio,
    }): _urlBuilder = urlBuilder, _dio = dio;


  final AppDio _dio;
  final UrlBuilder _urlBuilder;

  Future<List<Restaurant>> getRestaurants({
    required Location location, 
    int? limit, 
    int? offset,
    }) async {
      final uri = _urlBuilder.getRestaurants(
        latitude: location.lat.toString(), 
        longitude: location.lng.toString(),
        limit: limit.toString(),
        offset: offset.toString(),
      );

      final response = await _dio.httpClient.getUri<Map<String, dynamic>>(uri);
      final data = response.json();
      if(!response.isOk) {
        throw YandexEatsApiRequestFailure(
          statusCode: response.statusCode, 
          body: data,
          );
      }

      final restaurants = data['restaurants'] as List<dynamic>;
      return restaurants
        .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
        .toList();
    }
}
 
extension on Response<Map<String, dynamic>> {
  Map<String, dynamic> json() {
    try {
      return data!;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        YandexEatsApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}

extension on Response<dynamic> {
  bool get isOk => statusCode == HttpStatus.ok;
  bool get isCreated => statusCode == HttpStatus.created;
}
