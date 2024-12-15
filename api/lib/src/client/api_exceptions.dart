


abstract class YandexEatsApiException implements Exception {
  /// {@macro yandex_eats_api_exception}
  const YandexEatsApiException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Yandex Eats API exception error: $error';
}

/// {@template get_restaurant_by_location_failure}
/// Thrown during the get of restaurant by location if a failure occurs.
/// {@endtemplate}
class GetRestaurantByLocationFailure extends YandexEatsApiException {
  /// {@macro get_restaurant_by_location_failure}
  const GetRestaurantByLocationFailure(super.error);
}
